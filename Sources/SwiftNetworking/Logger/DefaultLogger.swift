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
	public var logLevel: LogLevel

	public var levelPrefix: [LogLevel: String]? = [
		.warning: "⚠️",
		.error: "❌"
	]
	
	public var messageUniversalPrefix: String? = "🌐"
	
	/**
	 The log level can be set either directly as `logLevel` parameter on init, or as `SWIFT_NETWORKING_LOG_LEVEL` env. variable value.
	 The input parameter has priority over env. variable setting.
	 If neither is set, the log level is set to `.debug` for DEBUG builds and to `.none` otherwise.
	 */
	public init(
		_ logLevel: LogLevel? = nil,
		options: [LogOptions] = []
	) {
		self.options = options
		
		if let customLogLevel = logLevel {
			self.logLevel = customLogLevel
		} else if let envDefinedLogLevelString = ProcessInfo.processInfo.environment[DefaultLogger.logLevelEnvKey],
				  let envDefinedLogLevel = LogLevel(rawValue: envDefinedLogLevelString) {
			self.logLevel = envDefinedLogLevel
		} else {
			#if DEBUG
			self.logLevel = .debug
			#else
			self.logLevel = .nothing
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
		if level >= logLevel {
			let prefix = (messageUniversalPrefix ?? "") + (levelPrefix?[level] ?? "")
			print("\(prefix) \(message)")
		}
	}
	
}
