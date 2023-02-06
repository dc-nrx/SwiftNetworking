//
//  Tools.swift
//  
//
//  Created by Dmytro Chapovskyi on 06.02.2023.
//

import Foundation

public typealias Query = [String: String?]
public typealias Headers = [String: String]

public extension URLRequest {
	
	init<T>(
		_ requestInfo: SwiftNetworking.RequestInfo<T>
	) {
		self.init(url: requestInfo.url,
				  httpMethod: requestInfo.method.rawValue,
				  headers: requestInfo.headers,
				  query: requestInfo.query)
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
