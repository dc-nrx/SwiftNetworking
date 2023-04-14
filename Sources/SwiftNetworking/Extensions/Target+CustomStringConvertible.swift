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
		if let query = query {
			for (key, value) in query {
				queryString += key + "=" + value.description
			}
		}
		
		var bodySuffixString = ""
		if let body = body {
			bodySuffixString = " ## bodyHash = \(body.hashValue)"
		}
		
		var headersNewLine = ""
		if let headers = headers {
			headersNewLine = " ↓\nHeaders = \(headers)"
		}
		
		return method.rawValue + " " + path + "?" + queryString + bodySuffixString + headersNewLine
	}
	
}
