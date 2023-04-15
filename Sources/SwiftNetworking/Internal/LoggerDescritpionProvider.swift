//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 15.04.2023.
//

import Foundation

internal protocol LoggerDescritpionProvider {

	func loggerDescription(_ options: [LogOptions]) -> String
}

extension URLResponse: LoggerDescritpionProvider {
	
	func loggerDescription(
		_ options: [LogOptions]
	) -> String {
		let urlString = url?.absoluteString ?? "<no url>"
		guard let httpResponse = self as? HTTPURLResponse else {
			return urlString
		}
		var result = "\(httpResponse.statusCode)" + " | " + urlString
		if options.contains(.showResponseHeaders) {
			result += ", Headers: \(httpResponse.allHeaderFields)"
		}
		return result
	}
}

extension URLRequest: LoggerDescritpionProvider {
	
	func loggerDescription(
		_ options: [LogOptions]
	) -> String {
		var result = httpMethod ?? "<no method>"
		result += " " + (url?.absoluteString ?? "<no url>")
		if options.contains(.showResponseHeaders) {
			let headers = allHTTPHeaderFields ?? [:]
			result += ", Headers: \(headers)"
		}
		return result
	}
}
