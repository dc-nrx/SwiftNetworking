//
//  NetworkService.swift
//  
//
//  Created by Dmytro Chapovskyi on 05.02.2023.
//

import Foundation

/**
 Adds headers to `RequestInfo` such as authorization, preffered language etc.
 */
public protocol RequestPreprocessor: AnyObject {
	
	func preprocess(_ target: inout some Target)
}

public protocol AuthorizationHandler {

	func performTokenRefresh() async throws
	func tokenRefreshRequired(error: Error?) -> Bool
}

/**
 The main protocol for sending requests / parsing responses. Has default implementation that handles request signing (and subsequent request re-sending if appropriate).
 */
public protocol Host {

	var requestPreprocessor: RequestPreprocessor? { get }
	var authorizationHandler: AuthorizationHandler? { get }

	var baseURLString: String { get }
	
	func request<T: Target> (
		_ target: T
	) async throws -> T.Response
}

public extension Host {

	/**
	 Default implementation (assumes no additional headers like Authorization stuff). If additional headers needed,
	 just conform to `HeaderProvider` - then another default implementation of the method will trigger (see below).
	 */
	func request<T: Target> (
		_ target: T
	) async throws -> T.Response {
		try await _recursive_request(target)
	}
		
}

private extension Host {
	
	/**
	 The default implementation takes care of request preprocessing and handles token expiration case.
	 */
	func _recursive_request<T: Target> (
		_ target: T,
		session: URLSession = .shared,
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
				return try await _recursive_request(target, session: session, repeatedRequest: true)
			} else {
				throw error
			}
		}
	}
	
}
