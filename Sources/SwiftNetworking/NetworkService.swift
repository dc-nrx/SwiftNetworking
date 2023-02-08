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
public protocol RequestSigniner: AnyObject {
	
	func sign<T>(_ requestInfo: inout RequestInfo<T>)
	func performTokenRefresh() async throws
	func tokenRefreshRequired(error: Error?) -> Bool
}

/**
 The main protocol for sending requests / parsing responses. Has default implementation that handles request signing (and subsequent request re-sending if appropriate).
 */
public protocol NetworkService {

	var requestSigner: RequestSigniner? { get }
	
	func request<T> (
		_ requestInfo: RequestInfo<T>
	) async throws -> T

}

public extension NetworkService {

	/**
	 Default implementation (assumes no additional headers like Authorization stuff). If additional headers needed,
	 just conform to `HeaderProvider` - then another default implementation of the method will trigger (see below).
	 */
	func request<T> (
		_ requestInfo: RequestInfo<T>
	) async throws -> T {
		try await _NetworkService_request(requestInfo)
	}
		
}

private extension NetworkService {
	
	func _NetworkService_request<T> (
		_ requestInfo: RequestInfo<T>,
		session: URLSession = .shared,
		repeatedRequest: Bool = false
	) async throws -> T {
		// Sign the request
		var signedRequest = requestInfo
		requestSigner?.sign(&signedRequest)
		let urlRequest = URLRequest(signedRequest)
		// Send it
		do {
			let (data, _) = try await session.data(for: urlRequest)
			return try requestInfo.parse(data)
		// Try to refresh token and repeat the process if it's the first attempt (and if appropriate).
		} catch {
			// Check conditions
			if !repeatedRequest,
			   requestSigner?.tokenRefreshRequired(error: error) == true {
				// Refresh token
				try await requestSigner?.performTokenRefresh()
				// Recursive call
				return try await _NetworkService_request(requestInfo, session: session, repeatedRequest: true)
			} else {
				throw error
			}
		}
	}
	
}
