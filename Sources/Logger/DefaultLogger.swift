//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 14.04.2023.
//

import Foundation

public class DefaultLogger: Logger {
	
	public static let logLevelEnvKey = "SWIFT_NETWORKING_LOG_LEVEL"

	public var options: [LogOptions]
	public var minLogLevel: LogLevel

	/// Added at the beginnig of each message.
	public var commonPrefix: String?

	/// Added after `commonPrefix` to each message with corresponding log level.
	public var levelPrefixes: [LogLevel: String]?
		
	/**
	 The log level can be set either directly as `logLevel` parameter on init, or as `SWIFT_NETWORKING_LOG_LEVEL` env. variable value.
	 The input parameter has priority over env. variable setting.
	 If neither is set, the log level is set to `.debug` for DEBUG builds and to `.none` otherwise.
	 */
	public init(
		_ logLevel: LogLevel? = nil,
		options: [LogOptions] = [],
		levelPrefixes: [LogLevel: String]? = [.warning: "⚠️", .error: "❌"],
		commonPrefix: String? = nil
	) {
		self.options = options
		self.levelPrefixes = levelPrefixes
		self.commonPrefix = commonPrefix
		
		if let customLogLevel = logLevel {
			self.minLogLevel = customLogLevel
		} else if let envDefinedLogLevelString = ProcessInfo.processInfo.environment[DefaultLogger.logLevelEnvKey],
				  let envDefinedLogLevel = LogLevel(rawValue: envDefinedLogLevelString) {
			self.minLogLevel = envDefinedLogLevel
		} else {
			#if DEBUG
			self.minLogLevel = .debug
			#else
			self.minLogLevel = .nothing
			#endif
		}
	}
	
	public func log(
		_ level: LogLevel,
		_ message: String,
		file: String = #file,
		function: String = #function,
		line: Int = #line
	) {
		if level >= minLogLevel {
			print("\(messagePrefix(level))\(message)")
		}
	}
	
	private func messagePrefix(_ logLevel: LogLevel) -> String {
		var prefix = ""
		if let commonPrefix {
			prefix += commonPrefix + " "
		}
		if let levelPrefix = levelPrefixes?[logLevel] {
			prefix += levelPrefix + " "
		}
		return prefix
	}
	
}
