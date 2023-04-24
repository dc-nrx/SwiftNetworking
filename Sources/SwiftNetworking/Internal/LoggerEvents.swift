//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 14.04.2023.
//

import Foundation
import ReplaceableLogger

internal enum LoggerEvent {

	case sending(URLRequest, _ previouslyHandeledErrors: [Error])
	case responseRecieved(Data, URLResponse)
	case urlRequestGenerated(any Target, URLRequest)
	case preprocess(any RequestPreprocessor, any Target)
	case errorResolutionStarted(Error, _ previousErrors: [Error])
	case errorResolutionFinished(Error, _ previousErrors: [Error])
	case unhandeledErrorOccured(Error, _ previousErrors: [Error])
	
}

internal extension Logger {
	
	func event(
		_ event: LoggerEvent,
		file: String = #file,
		function: String = #function,
		line: Int = #line
	) {
		let lg: (LogLevel, @autoclosure ()->String) -> () = { level, message in
			log(level, message(), file: file, function: function, line: line)
		}
		switch event {
			
		case .sending(let request, let previousErrors):
			let prefix = previousErrors.isEmpty ? "" : "[Repeated] "
			lg(.debug, construct("\(prefix)Sending \(request.loggerDescription)",
								 error: nil,
								 previousErrors: previousErrors))
			lg(.verbose, bodyString(request.httpBody))
		
		case .responseRecieved(let data, let response):
			lg(.debug, "Response received: \(response.loggerDescription) | \(data)")
			lg(.verbose, bodyString(data))
		
		case .urlRequestGenerated(let target, let request):
			lg(.verbose, "URL Request from target \(target) generated: \(request)")
		
		case .preprocess(let target, let preprocessor):
			lg(.verbose, "Target \(target) preprocessing started with \(preprocessor)")
		
		case .errorResolutionStarted(let error, let previousErrors):
			lg(.warning, construct("Error resolution started",
								 error: error,
								 previousErrors: previousErrors))
		
		case .errorResolutionFinished(let error, let previousErrors):
			lg(.debug, construct("Error resolution finished",
								 error: error,
								 previousErrors: previousErrors))
		
		case .unhandeledErrorOccured(let error, let previousErrors):
			lg(.error, construct("Unhandeled error occured",
								 error: error,
								 previousErrors: previousErrors))
		}
	}
	
	func construct(
		_ originalMessage: String,
		error: Error?,
		previousErrors: [Error]
	) -> String {
		var message = originalMessage
		if let error = error {
			message += " | error: \(error)"
		}
		if !previousErrors.isEmpty {
			message += "\nPREVIOUS ERRORS COUNT: \(previousErrors.count)"
		}
		return message
	}
	
	func bodyString(_ data: Data?) -> String {
		
		guard let data else {
			return "<body is empty>"
		}
		
		guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
			  let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
			return "<parse body to JSON string failed>"
		}
		
		return "Body: " + String(decoding: jsonData, as: UTF8.self)
	}
	
	func headersString(
		from headers: [AnyHashable: Any]?
	) -> String {
		guard let headers,
				!headers.isEmpty else {
			return "<empty headers>"
		}
		guard let data = try? JSONSerialization.data(withJSONObject: headers, options: .prettyPrinted), // first of all convert json to the data
			  let convertedString = String(data: data, encoding: .utf8) else { // the data will be converted to the string
			return "<headers string generation failed>"
		}
		
		return "Headers: " + convertedString
	}
}
