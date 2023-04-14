//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 14.04.2023.
//

import Foundation

internal enum LoggerEvent {

	case sending(URLRequest, _ previouslyHandeledErrors: [Error])
	case responseRecieved(Data, URLResponse)
	case urlRequestGenerated(any Target, URLRequest)
	case preprocess(any RequestPreprocessor, any Target)
	case errorResolutionStarted(Error, _ previousErrors: [Error])
	case errorResolutionFinished(Error, _ previousErrors: [Error])
	case unhandeledErrorOccured(Error, _ previousErrors: [Error])
		
	var level: LogLevel {
		switch self {
		case .urlRequestGenerated,
				.preprocess:
			return .verbose
			
		case .sending,
				.responseRecieved,
				.errorResolutionFinished:
			return .debug

		case .errorResolutionStarted:
			return .warning

		case .unhandeledErrorOccured:
			return .error
		}
	}
}

internal extension Logger {
	
	func event(
		_ event: LoggerEvent,
		file: String = #file,
		function: String = #function,
		line: Int = #line
	) {
		var message: String
		switch event {
		case .sending(let request, let previousErrors):
			message = construct("Sending \(request.customDescription(options: options))",
								error: nil,
								previousErrors: previousErrors)
		case .responseRecieved(let data, let response):
			message = "Response received: \(response.customDescription(options: options)) | \(data)" 
		case .urlRequestGenerated(let target, let request):
			message = "URL Request from target \(target) generated: \(request)"
		case .preprocess(let target, let preprocessor):
			message = "Target \(target) preprocessing started with \(preprocessor)"
		case .errorResolutionStarted(let error, let previousErrors):
			message = construct("Error resolution started", error: error,
								previousErrors: previousErrors)
		case .errorResolutionFinished(let error, let previousErrors):
			message = construct("Error resolution finished", error: error,
								previousErrors: previousErrors)
		case .unhandeledErrorOccured(let error, let previousErrors):
			message = construct("Unhandeled error occured", error: error,
								previousErrors: previousErrors)
		}

		log(event.level, message, file: file, function: function, line: line)
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
			message += "\nPREVIOUS ERRORS: \(previousErrors)"
		}
		return message
	}
}
