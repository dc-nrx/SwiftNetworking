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
	
	func sign(_ requestInfo: inout some TargetType)
	func performTokenRefresh() async throws
	func tokenRefreshRequired(error: Error?) -> Bool
}

/**
 The main protocol for sending requests / parsing responses. Has default implementation that handles request signing (and subsequent request re-sending if appropriate).
 */
public protocol NetworkService {

	var requestSigner: RequestSigniner? { get }
	
	func request<T: TargetType> (
		_ target: T
	) async throws -> T.Response

}

public extension NetworkService {

	/**
	 Default implementation (assumes no additional headers like Authorization stuff). If additional headers needed,
	 just conform to `HeaderProvider` - then another default implementation of the method will trigger (see below).
	 */
	func request<T: TargetType> (
		_ target: T
	) async throws -> T.Response {
		try await _NetworkService_request(target)
	}
		
}

private extension NetworkService {
	
	func _NetworkService_request<T: TargetType> (
		_ target: T,
		session: URLSession = .shared,
		repeatedRequest: Bool = false
	) async throws -> T.Response {
		// Sign the request
		var signedTarget = target
		requestSigner?.sign(&signedTarget)
		let urlRequest = URLRequest(target)
		print("### \(urlRequest)")
		// Send it
		do {
			let (data, _) = try await session.data(for: urlRequest)
			return try target.parse(data)
		// Try to refresh token and repeat the process if it's the first attempt (and if appropriate).
		} catch {
			// Check conditions
			if !repeatedRequest,
			   requestSigner?.tokenRefreshRequired(error: error) == true {
				// Refresh token
				try await requestSigner?.performTokenRefresh()
				// Recursive call
				return try await _NetworkService_request(target, session: session, repeatedRequest: true)
			} else {
				throw error
			}
		}
	}
	
}
