//
//  RegularHost.swift
//  
//
//  Created by Dmytro Chapovskyi on 11.04.2023.
//

import Foundation

open class RegularHost: Host {
	
	public var requestPreprocessor: RequestPreprocessor?
	public var authorizationHandler: AuthorizationHandler?
	public var baseURLString: String
	public var session: URLSession
	
	public init(
		requestPreprocessor: RequestPreprocessor? = nil,
		authorizationHandler: AuthorizationHandler? = nil,
		baseURLString: String,
		session: URLSession = .shared
	) {
		self.requestPreprocessor = requestPreprocessor
		self.authorizationHandler = authorizationHandler
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
		try await recursiveRequest(target, isInitialRequest: true)
	}
}

private extension RegularHost {
	
	//TODO: instead of `isInitialRequest` provide errors array; stop as soon as some error happens the 2nd time
	func recursiveRequest<T: Target> (
		_ target: T,
		isInitialRequest: Bool
	) async throws -> T.Response {
		let urlRequest = preprocessedUrlRequest(from: target)
		do {
			let (data, _) = try await session.data(for: urlRequest)
			return try target.parse(data)
		} catch {
			if !isInitialRequest {
				return try await attemptResendWithRefreshedToken(target, initialError: error)
			} else {
				throw error
			}
		}
	}
	
	func attemptResendWithRefreshedToken<T: Target>(
		_ target: T,
		initialError: Error
	) async throws -> T.Response {
		if authorizationHandler?.tokenRefreshRequired(error: initialError) == true {
			try await authorizationHandler?.performTokenRefresh()
			return try await recursiveRequest(target, isInitialRequest: false)
		} else {
			throw initialError
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
