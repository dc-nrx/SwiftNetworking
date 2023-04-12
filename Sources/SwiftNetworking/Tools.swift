//
//  Tools.swift
//  
//
//  Created by Dmytro Chapovskyi on 06.02.2023.
//

import Foundation

public typealias Headers = [String: String]

extension URLRequest {
	
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
		
		var headers = target.headers ?? [:]
		if target.body != nil {
			headers["Content-Type"] = "application/json"
		}
		self.allHTTPHeaderFields = headers
		self.httpMethod = target.method.rawValue
		self.httpBody = target.body
	}
}

extension Array {
	
	func appending(_ newElement: Element) -> Self {
		var result = self
		result.append(newElement)
		return result
	}
}

public func == (lhs: Error, rhs: Error) -> Bool {
	guard type(of: lhs) == type(of: rhs) else { return false }
	let error1 = lhs as NSError
	let error2 = rhs as NSError
	return error1.domain == error2.domain && error1.code == error2.code && "\(lhs)" == "\(rhs)"
}

extension Equatable where Self : Error {
	public static func == (lhs: Self, rhs: Self) -> Bool {
		lhs as Error == rhs as Error
	}
}
