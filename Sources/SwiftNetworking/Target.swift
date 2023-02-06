//
//  Resource.swift
//  
//
//  Created by Dmytro Chapovskyi on 05.02.2023.
//

import Foundation

public struct Target<T> {

	public enum Method: String {
		case POST, GET, PUT, PATCH, DELETE
	}

	let url: URL
	let method: Method
	let parse: (Data) throws -> T
	
	init(
		url: URL,
		method: Method,
		parse: @escaping (Data) throws -> T
	) {
		self.url = url
		self.method = method
		self.parse = parse
	}
	
}

public extension Target where T: Decodable {
	
	init(
		url: URL,
		method: Method
	) {
		self.init(url: url, method: method) { data in
			try JSONDecoder().decode(T.self, from: data)
		}
		
	}
}
