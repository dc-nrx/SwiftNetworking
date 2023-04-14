//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 14.04.2023.
//

import Foundation

public struct LogOptions: OptionSet {
	
	public static let omitResponseHeaders = LogOptions(rawValue: 1 << 0)
	
	public let rawValue: Int
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
}

public enum LogLevel: String, CaseIterable, Comparable {

	case verbose
	case debug
	case none
	
	public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
		let all = LogLevel.allCases
		return all.firstIndex(of: lhs)! < all.firstIndex(of: rhs)!
	}
}

public protocol Logger {
	
	var options: [LogOptions] { get }
	
	func log(
		_ level: LogLevel,
		_ message: String,
		file: String,
		function: String,
		line: Int
	)
}

public extension Logger {
		
	func log(
		_ level: LogLevel,
		_ message: String,
		file: String = #file,
		function: String = #function,
		line: Int = #line
	) {
		log(level, message, file: file, function: function, line: line)
	}
}
