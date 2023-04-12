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
	 If the request fails and `authorizationHandler != nil`, try to refresh token and re-send the request once again.
	 
	 Please see `RequestPreprocessor` and `AuthorizationHandler` docs for additional details.
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
			if shouldAttemptRecovery(from: extendedErrors) {
				return try await attemptRecovery(target, errors: extendedErrors)
			} else {
				throw previousErrors.isEmpty ? error : RegularHostError.recoveryFromResponseErrorsFailed(extendedErrors)
			}
		}
	}
	
	func attemptRecovery<T: Target>(
		_ target: T,
		errors: [Error]
	) async throws -> T.Response {
		guard let errorToHandle = errors.last else {
			throw RegularHostError.attemptToRecoverWithEmptyErrorsList
		}
		
		if errorHandler?.canHandle(error: errorToHandle) == true {
			try await errorHandler?.handle(error: errorToHandle)
			return try await recursiveRequest(target, previousErrors: errors)
		} else {
			throw RegularHostError.recoveryFromResponseErrorsFailed(errors)
		}
	}
	
	func preprocessedUrlRequest<T: Target>(
		from target: T
	) -> URLRequest {
		var signedTarget = target
		requestPreprocessor?.preprocess(&signedTarget)
		return URLRequest(host: baseURLString, signedTarget)
	}

	func shouldAttemptRecovery(
		from errors: [Error]
	) -> Bool {
		guard let lastError = errors.last,
			  errorHandler?.canHandle(error: lastError) == true else {
			return false
		}
		
		// Comparing descriptions can't give false negative result,
		// which is the only thing that matters here
		// (since may lead to an infinite recursion)
		return !errors.dropLast().contains { "\($0)" == "\(lastError)" }
	}
}
