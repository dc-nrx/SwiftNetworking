//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 14.04.2023.
//

import Foundation



public enum LogLevel: String, CaseIterable, Comparable {

	case verbose
	case debug
	case warninig
	case error
	case none
	
	public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
		let all = LogLevel.allCases
		return all.firstIndex(of: lhs)! < all.firstIndex(of: rhs)!
	}
}

public protocol Logger {
	
	func log(
		_ level: LogLevel,
		_ message: String,
		file: String,
		function: String,
		line: Int
	)
}

public class SimpleLogger: Logger {
	
	public static let logLevelEnvKey = "SWIFT_NETWORKING_LOG_LEVEL"
	
	public var logLevel: LogLevel = {
		#if DEBUG
		var result = LogLevel.debug
		#else
		var result = LogLevel.none
		#endif
		if let customLogLevelString = ProcessInfo.processInfo.environment[SimpleLogger.logLevelEnvKey],
		   let customLogLevel = LogLevel(rawValue: customLogLevelString) {
			result = customLogLevel
		}
		
		return result
	}()
	
	public func log(
		_ level: LogLevel,
		_ message: String,
		file: String = #file,
		function: String = #function,
		line: Int = #line
	) {
		if level >= logLevel {
			let fileName = file.components(separatedBy: "/").last ?? file
			print("[\(logLevel.rawValue.uppercased())] \(fileName):\(function):\(line) \(message)")
		}
	}
	
}
