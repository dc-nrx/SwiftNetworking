//
//  RegularHost.swift
//  
//
//  Created by Dmytro Chapovskyi on 11.04.2023.
//

import Foundation
import ReplaceableLogger

public enum RegularHostError: Error {
	case recoveryFromResponseErrorsFailed([Error])
	case attemptToRecoverWithEmptyErrorsList
}

open class RegularHost: Host {
	
	public var protocolName: String
	public var address: String
	public var session: URLSession

	public var requestPreprocessor: RequestPreprocessor?
	public var errorHandler: ErrorHandler?
	public var logger: Logger?
	
	public init(
		protocolName: String = "https",
		_ address: String,
		requestPreprocessor: RequestPreprocessor? = nil,
		errorHandler: ErrorHandler? = nil,
		session: URLSession = .shared,
		logger: Logger? = DefaultLogger(commonPrefix: "🌐")
	) {
		self.protocolName = protocolName
		self.address = address
		self.requestPreprocessor = requestPreprocessor
		self.errorHandler = errorHandler
		self.session = session
		self.logger = logger
	}
	
	/**
	 Send the request.
	 
	 If `requestPreprocessor != nil`, call `requestPreprocessor.preprocess` on the target request first.
	 If the request fails and `errorHandler != nil`, attempt to recover from it and re-send the request once again.
	 
	 Please see `RequestPreprocessor` and `ErrorHandler` docs for additional details.
	 */
	open func send<T: Target> (
		_ target: T
	) async throws -> T.Response {
		try await recursiveRequest(target)
	}
}

private extension RegularHost {

	func recursiveRequest<T: Target> (
		_ target: T,
		previousErrors: [Error] = []
	) async throws -> T.Response {
		let urlRequest = try preprocessedUrlRequest(from: target)
		do {
			logger?.event(.sending(urlRequest, previousErrors))
			let (data, response) = try await session.data(for: urlRequest)
			logger?.event(.responseRecieved(data, response))
			return try target.mapResponseData(data)
		} catch {
			let extendedErrors = previousErrors.appending(error)
			if !previousErrors.contains(where: { $0 == error }) {
				logger?.event(.errorResolutionStarted(error, previousErrors))
				try await errorHandler?.handle(error: error)
				logger?.event(.errorResolutionFinished(error, previousErrors))
				return try await recursiveRequest(target, previousErrors: extendedErrors)
			} else {
				logger?.event(.unhandeledErrorOccured(error, previousErrors))
				throw previousErrors.isEmpty ? error : RegularHostError.recoveryFromResponseErrorsFailed(extendedErrors)
			}
		}
	}
	
	func preprocessedUrlRequest<T: Target>(
		from target: T
	) throws -> URLRequest {
		var signedTarget = target
		if let preprocessor = requestPreprocessor {
			logger?.event(.preprocess(preprocessor, target))
			preprocessor.preprocess(&signedTarget)
		}
		let baseUrlString = protocolName + "://" + address
		let request = try URLRequest(baseUrl: baseUrlString, signedTarget)
		logger?.event(.urlRequestGenerated(signedTarget, request))
		return request
	}

}
