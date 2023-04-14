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
