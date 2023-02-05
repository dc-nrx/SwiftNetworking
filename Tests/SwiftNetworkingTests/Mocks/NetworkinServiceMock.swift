//
//  NetworkinServiceMock.swift
//  
//
//  Created by Dmytro Chapovskyi on 05.02.2023.
//

import Foundation
import SwiftNetworking

class NetworkServiceMock: NetworkService, HeadersProvider {
	
	var headers = [
		"auth": "azaza"
	]
	
//	func request<T>(_ target: Target<T>, headers: [String : String]) async throws -> T {
//		let extendedHeaders = authHeaders.merging(headers, uniquingKeysWith: { $1 })
//		return try await request(target, extendedHeaders: extendedHeaders)
//	}
}
