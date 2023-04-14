//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 14.04.2023.
//

import Foundation

internal enum LoggerEvent: CustomStringConvertible {

	case sending(any Target, _ previouslyHandeledErrors: [Error])
	case responseRecieved(Data, URLResponse)
	case urlRequestGenerated(any Target, URLRequest)
	case preprocess(any RequestPreprocessor, any Target)
	case errorResolutionStarted(Error, _ previousErrors: [Error])
	case errorResolutionFinished(Error, _ previousErrors: [Error])
	case repeatedErrorOccured(Error, _ previousErrors: [Error])
	
	var description: String {
		switch self {
		case .sending(let target, let errors):
			return "Sending \(target); previous errors = \(errors)"
		case .responseRecieved(let data, let response):
			return "Response received: data = \(data); response = \(response)"
		case .urlRequestGenerated(let target, let request):
			return "URL Request from target \(target) generated: \(request)"
		case .preprocess(let target, let preprocessor):
			return "Target \(target) preprocessing started with \(preprocessor)"
		case .errorResolutionStarted(let error, let previousErrors):
			return "Error resolution started \(error); previous errors = \(previousErrors)"
		case .errorResolutionFinished(let error, let previousErrors):
			return "Error resolution finished \(error); previous errors = \(previousErrors)"
		case .repeatedErrorOccured(let error, let previousErrors):
			return "Repeated error occured \(error); previous errors = \(previousErrors)"
		}
	}
	
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
		log(event.level, event.description, file: file, function: function, line: line)
	}
}
