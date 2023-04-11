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
	 The default implementation takes care of request preprocessing and handles token expiration case.
	 */
	open func request<T: Target> (
		_ target: T
	) async throws -> T.Response {
		try await _recursive_request(target)
	}
		
}

private extension RegularHost {
	
	/**
	 The default implementation takes care of request preprocessing and handles token expiration case.
	 */
	func _recursive_request<T: Target> (
		_ target: T,
		repeatedRequest: Bool = false
	) async throws -> T.Response {
		// Sign the request
		var signedTarget = target
		requestPreprocessor?.preprocess(&signedTarget)
		
		let urlRequest = URLRequest(host: baseURLString, signedTarget)
		// Send it
		do {
			let (data, _) = try await session.data(for: urlRequest)
			return try signedTarget.parse(data)
		// Try to refresh token and repeat the process if it's the first attempt (and if appropriate).
		} catch {
			// Check conditions
			if !repeatedRequest,
				authorizationHandler?.tokenRefreshRequired(error: error) == true {
				// Refresh token
				try await authorizationHandler?.performTokenRefresh()
				// Recursive call
				return try await _recursive_request(target, repeatedRequest: true)
			} else {
				throw error
			}
		}
	}

}
