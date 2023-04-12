//
//  RegularHost.swift
//  
//
//  Created by Dmytro Chapovskyi on 11.04.2023.
//

import Foundation

public enum RegularHostError: Error {
	case recoveryFromResponseErrorsFailed([Error])
	case attemptToRecoverWithEmptyErrorsList
}

open class RegularHost: Host {
	
	public var requestPreprocessor: RequestPreprocessor?
	public var errorHandler: ErrorHandler?
	public var baseURLString: String
	public var session: URLSession
	
	public init(
		requestPreprocessor: RequestPreprocessor? = nil,
		errorHandler: ErrorHandler? = nil,
		baseURLString: String,
		session: URLSession = .shared
	) {
		self.requestPreprocessor = requestPreprocessor
		self.errorHandler = errorHandler
		self.baseURLString = baseURLString
		self.session = session
	}
	
	/**
	 Send the request.
	 
	 If `requestPreprocessor != nil`, call `requestPreprocessor.preprocess` on the target request first.
	 If the request fails and `errorHandler != nil`, attempt to recover from it and re-send the request once again.
	 
	 Please see `RequestPreprocessor` and `ErrorHandler` docs for additional details.
	 */
	open func request<T: Target> (
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
		let urlRequest = preprocessedUrlRequest(from: target)
		do {
			let (data, _) = try await session.data(for: urlRequest)
			return try target.parse(data)
		} catch {
			let extendedErrors = previousErrors.appending(error)
			if !previousErrors.contains(where: { $0 == error }) {
				try await errorHandler?.handle(error: error)
				return try await recursiveRequest(target, previousErrors: extendedErrors)
			} else {
				throw previousErrors.isEmpty ? error : RegularHostError.recoveryFromResponseErrorsFailed(extendedErrors)
			}
		}
	}
	
	func preprocessedUrlRequest<T: Target>(
		from target: T
	) -> URLRequest {
		var signedTarget = target
		requestPreprocessor?.preprocess(&signedTarget)
		return URLRequest(host: baseURLString, signedTarget)
	}

}
