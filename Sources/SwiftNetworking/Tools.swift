//
//  Tools.swift
//  
//
//  Created by Dmytro Chapovskyi on 06.02.2023.
//

import Foundation

public typealias Headers = [String: String]

public extension URLRequest {
	
	init<T: Target>(
		_ target: T
	) {
		self.init(url: target.url,
				  httpMethod: target.method.rawValue,
				  headers: target.headers,
				  query: target.query)
	}
	
	init(
		url: URL,
		httpMethod: String,
		headers: Headers? = nil,
		query: Query? = nil
	) {
		var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
		urlComponents.queryItems = query?.map { URLQueryItem(name: $0, value: $1) }
		urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
		
		self.init(url: urlComponents.url!)
		self.allHTTPHeaderFields = headers
		self.httpMethod = httpMethod
	}
}

public extension URL {
	init!(
		host: String,
		path: String
	) {
		self.init(string: host + "/" + path)!
	}
}
