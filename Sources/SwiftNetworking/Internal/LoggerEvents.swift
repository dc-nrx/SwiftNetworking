//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 14.04.2023.
//

import Foundation

internal enum LoggerEvent {

	case sending(any Target, _ previouslyHandeledErrors: [Error])
	case responseRecieved(Data, URLResponse)
	case urlRequestGenerated(any Target, URLRequest)
	case preprocess(any RequestPreprocessor, any Target)
	case errorResolutionStarted(Error, _ previousErrors: [Error])
	case errorResolutionFinished(Error, _ previousErrors: [Error])
	case repeatedErrorOccured(Error, _ previousErrors: [Error])
		
	var level: LogLevel {
		switch self {
		case .urlRequestGenerated,
				.preprocess:
			return .verbose
			
		case .sending,
				.responseRecieved,
				.errorResolutionStarted,
				.errorResolutionFinished,
				.repeatedErrorOccured:
			return .debug
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
		case .sending(let target, let errors):
			message = "Sending \(target)"
			if !errors.isEmpty {
				message += "; previous errors = \(errors)"
			}
		case .responseRecieved(let data, let response):
			message = "Response received: \(data); \(response.customDescription(options: options))"
		case .urlRequestGenerated(let target, let request):
			message = "URL Request from target \(target) generated: \(request)"
		case .preprocess(let target, let preprocessor):
			message = "Target \(target) preprocessing started with \(preprocessor)"
		case .errorResolutionStarted(let error, let previousErrors):
			message = "Error resolution started \(error); previous errors = \(previousErrors)"
		case .errorResolutionFinished(let error, let previousErrors):
			message = "Error resolution finished \(error); previous errors = \(previousErrors)"
		case .repeatedErrorOccured(let error, let previousErrors):
			message = "Repeated error occured \(error); previous errors = \(previousErrors)"
		}

		log(event.level, message, file: file, function: function, line: line)
	}
}
