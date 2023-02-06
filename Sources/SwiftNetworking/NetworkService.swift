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
		_ request: Request<T>
	) async throws -> T
	
}

public extension NetworkService {

	/**
	 Default implementation (assumes no additional headers like Authorization stuff). If additional headers needed,
	 just conform to `HeaderProvider` - then another default implementation of the method will trigger (see below).
	 */
	func request<T> (
		_ request: Request<T>
	) async throws -> T {
		try await self.request(request)
	}
		
}

/// Shorthand to just use custom headers and attach them automatically
public extension NetworkService where Self: HeadersProvider {
	
	func request<T> (
		_ request: Request<T>
	) async throws -> T {
		var requestWithExtendedHeaders = request
		requestWithExtendedHeaders.headers = request.headers.merging(headers, uniquingKeysWith: { $1 })
		return try await self._NetworkService_request(requestWithExtendedHeaders)
	}
	
}

private extension NetworkService {
	
	/// The final destination of default implementations. Builds and sends the request.
	func _NetworkService_request<T> (
		_ request: Request<T>,
		session: URLSession = .shared
	) async throws -> T {
		let urlRequest = URLRequest(request: request)
		let (data, _) = try await session.data(for: urlRequest)
		return try request.parse(data)
	}
}
