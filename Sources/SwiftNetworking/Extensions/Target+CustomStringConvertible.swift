//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 14.04.2023.
//

import Foundation

public extension Target {
	
	var description: String {
		var queryString = ""
		if let query = query,
           !query.values.compactMap({ $0 }).isEmpty {
			queryString += "?"
			for (key, value) in query {
                guard let value else { continue }
				queryString += key + "=" + value.description
			}
		}
		
		var bodyString = ""
		if let body = body {
			bodyString = ", body = \(body)"
		}
		
		var headersString = ""
		if let headers = headers {
			headersString = ", Headers = \(headers)"
		}
		
		return method.rawValue + " " + path + queryString + bodyString + headersString
	}
	
}
