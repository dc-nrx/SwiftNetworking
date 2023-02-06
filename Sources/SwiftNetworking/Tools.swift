//
//  Tools.swift
//  
//
//  Created by Dmytro Chapovskyi on 06.02.2023.
//

import Foundation

public typealias Query = [String: CustomStringConvertible]
public typealias Headers = [String: String]

public extension URLRequest {
	
	init<T>(
		target: Target<T>,
		headers: Headers? = nil,
		query: Query? = nil
	) {
		self.init(url: target.url, httpMethod: target.method.rawValue, headers: headers, query: query)
	}
	
	init(
		url: URL,
		httpMethod: String,
		headers: Headers? = nil,
		query: Query? = nil
	) {
		self.init(url: url)
		self.allHTTPHeaderFields = headers
		self.httpMethod = httpMethod
	}
}
