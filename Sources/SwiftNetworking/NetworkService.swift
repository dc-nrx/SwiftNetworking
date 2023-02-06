//
//  NetworkService.swift
//  
//
//  Created by Dmytro Chapovskyi on 05.02.2023.
//

import Foundation

public protocol NetworkService {
	
	func request<T> (
		_ target: Target<T>,
		headers: [String: String]
	) async throws -> T
	
}

public extension NetworkService {

	/// Main method - Shorthand
	func request<T> (
		_ target: Target<T>
	) async throws -> T {
		try await request(target, headers: [:])
	}
	
	/// Default implementation (assumes no additional headers like Authorization stuff)
	func request<T> (
		_ target: Target<T>,
		headers: [String: String]
	) async throws -> T {
		try await request(target, extendedHeaders: headers)
	}
	
	/// The final destination of default implementations. Builds and sends the request.
	func request<T> (
		_ target: Target<T>,
		extendedHeaders: [String: String]?,
		session: URLSession = .shared
	) async throws -> T {
		let request = URLRequest(target: target, headers: extendedHeaders)
		let (data, _) = try await session.data(for: request)
		return try target.parse(data)
	}
}

public protocol HeadersProvider {
	var headers: [String: String] { get }
}

/// Shorthand to just use custom headers and attach them automatically
public extension NetworkService where Self: HeadersProvider {
	
	func request<T> (
		_ target: Target<T>,
		headers: [String: String]
	) async throws -> T {
		let extendedHeaders = self.headers.merging(headers, uniquingKeysWith: { $1 })
		return try await request(target, extendedHeaders: extendedHeaders)
	}
	
}
