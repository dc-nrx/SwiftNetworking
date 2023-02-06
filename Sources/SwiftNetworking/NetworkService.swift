//
//  NetworkService.swift
//  
//
//  Created by Dmytro Chapovskyi on 05.02.2023.
//

import Foundation

public protocol HeadersProvider {
	var headers: [String: String] { get }
}

public protocol NetworkService {
	
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
		try await request(requestInfo)
	}
		
}

/// Shorthand to just use custom headers and attach them automatically
public extension NetworkService where Self: HeadersProvider {
	
	func request<T> (
		_ requestInfo: RequestInfo<T>
	) async throws -> T {
		var requestInfoWithExtendedHeaders = requestInfo
		requestInfoWithExtendedHeaders.headers = requestInfo.headers.merging(headers, uniquingKeysWith: { $1 })
		return try await self._NetworkService_request(requestInfoWithExtendedHeaders)
	}
	
}

private extension NetworkService {
	
	/// The final destination of default implementations. Builds and sends the request.
	func _NetworkService_request<T> (
		_ requestInfo: RequestInfo<T>,
		session: URLSession = .shared
	) async throws -> T {
		let urlRequest = URLRequest(requestInfo)
		let (data, _) = try await session.data(for: urlRequest)
		return try requestInfo.parse(data)
	}
}
