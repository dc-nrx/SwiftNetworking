//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 15.04.2023.
//

import Foundation
import ReplaceableLogger

internal protocol LoggerDescritpionProvider {

	var loggerDescription: String { get }
}

extension URLResponse: LoggerDescritpionProvider {
	
	var loggerDescription: String {
		let urlString = url?.absoluteString ?? "<no url>"
		if let httpResponse = self as? HTTPURLResponse {
			return "\(httpResponse.statusCode)" + " | " + urlString
		} else {
			return urlString
		}
	}
}

extension URLRequest: LoggerDescritpionProvider {
	
	var loggerDescription: String {
		var result = httpMethod ?? "<no method>"
		result += " " + (url?.absoluteString ?? "<no url>")
		return result
	}
}
