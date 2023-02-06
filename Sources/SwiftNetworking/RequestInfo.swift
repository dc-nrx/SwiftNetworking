//
//  Resource.swift
//  
//
//  Created by Dmytro Chapovskyi on 05.02.2023.
//

import Foundation

public struct RequestInfo<T> {

	public enum Method: String {
		case POST, GET, PUT, PATCH, DELETE
	}

	public var url: URL
	public var method: Method
	public var query: Query?
	public var headers: Headers
	public var parse: (Data) throws -> T
	
	public init(
		url: URL,
		method: Method,
		query: Query? = nil,
		headers: Headers = [:],
		parse: @escaping (Data) throws -> T
	) {
		self.url = url
		self.query = query
		self.method = method
		self.headers = headers
		self.parse = parse
	}
	
}

public extension RequestInfo where T: Decodable {
	
	init(
		url: URL,
		method: Method,
		query: Query? = nil
	) {
		self.init(url: url, method: method, query: query) { data in
			try JSONDecoder().decode(T.self, from: data)
		}
		
	}
}
