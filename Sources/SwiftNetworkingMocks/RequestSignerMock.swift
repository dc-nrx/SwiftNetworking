//
//  RequestSignerMock.swift
//  
//
//  Created by Dmytro Chapovskyi on 09.04.2023.
//

import Foundation
import SwiftNetworking

open class RequestPreprocessorMock: RequestPreprocessor {
	
	public var tokenValue: String
	
	public var authorizationKey = "Authorization"
	public var tokenRefreshedCountString = "0"
	
	public init(
		tokenValue: String = "--Token Placeholder--"
	) {
		self.tokenValue = tokenValue
	}
	
	public func preprocess(_ target: inout some Target) {
		var headers = target.headers ?? [:]
		headers[authorizationKey] = "Bearer " + tokenValue
		target.headers = headers
	}
}

open class AuthorizationHandlerMock: ErrorHandler {
	
	open var refreshTokenRequiredMock = false
	open var tokenRefreshCount = 0
	
	public init() { }
	
	open func handle(error: Error) async throws {
		tokenRefreshCount += 1
	}
	
	open func canHandle(error: Error) -> Bool {
		refreshTokenRequiredMock
	}
	
}

