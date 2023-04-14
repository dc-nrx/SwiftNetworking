//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 14.04.2023.
//

import Foundation

public extension URLRequest {
	
	init<T: Target>(
		host: String,
		_ target: T
	) throws {
		let url = try URL(host: host, target)
		self.init(url: url)
		
		let contentTypeKey = "Content-Type"
		let contentTypeJson = "application/json"
			
		var headers = target.headers ?? [:]
		if target.body != nil,
			headers[contentTypeKey] != nil {
			headers[contentTypeKey] = contentTypeJson
		}
		
		self.allHTTPHeaderFields = headers
		self.httpMethod = target.method.rawValue
		self.httpBody = target.body
	}

}
