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
		host: String,
		_ target: T
	) {
		var hostNormalized = host
		if host.last == "/" && target.path.first == "/" {
			hostNormalized.removeLast()
		} else if host.last != "/" && target.path.first != "/" {
			hostNormalized += "/"
		}
		
		let url = URL(string: hostNormalized + target.path)!
		var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
		urlComponents.queryItems = target.query?.map { URLQueryItem(name: $0, value: "\($1)") }
		urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
		
		self.init(url: urlComponents.url!)
		self.allHTTPHeaderFields = target.headers
		self.httpMethod = target.method.rawValue
		self.httpBody = target.body
	}
}
