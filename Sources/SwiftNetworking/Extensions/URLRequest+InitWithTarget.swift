//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 14.04.2023.
//

import Foundation

public extension URLRequest {
	
	init<T: Target>(
		baseUrl: String,
		_ target: T
	) throws {
		let url = try URL(baseUrl: baseUrl, target)
		self.init(url: url)
		
		self.allHTTPHeaderFields = target.headers
        if target.body != nil,
           self.value(forHTTPHeaderField: "Content-Type") == nil {
            self.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
		self.httpMethod = target.method.rawValue
		self.httpBody = target.body
	}

}
