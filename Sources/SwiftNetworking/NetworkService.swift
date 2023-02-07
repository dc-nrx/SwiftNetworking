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
public protocol RequestSigniner {
	
	func sign<T>(_ requestInfo: inout RequestInfo<T>)
	func refreshToken() async throws
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
		var signedRequest = requestInfo
		requestSigner?.sign(&signedRequest)
		let urlRequest = URLRequest(requestInfo)
		do {
			let (data, _) = try await session.data(for: urlRequest)
			return try requestInfo.parse(data)
		} catch {
			if !repeatedRequest,
			   let requestSigner = requestSigner,
			   requestSigner.tokenRefreshRequired(error: error) {
				try await requestSigner.refreshToken()
				return try await _NetworkService_request(requestInfo, session: session, repeatedRequest: true)
			} else {
				throw error
			}
		}
	}
}
