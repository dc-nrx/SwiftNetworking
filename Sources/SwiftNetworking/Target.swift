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
	let method: Method = .GET
	let parse: (Data) throws -> T
}

public extension Target where T: Decodable {
	
	init(url: URL) {
		self.url = url
		self.parse = { data in
			try JSONDecoder().decode(T.self, from: data)
   		}
	}
}
