//
//  RequestSignerMock.swift
//  
//
//  Created by Dmytro Chapovskyi on 09.04.2023.
//

import Foundation
import SwiftNetworking

open class RequestPreprocessorMock: RequestPreprocessor {
	
	public var authorizationValue: String
	
	public var authorizationKey = "Authorization"
	
	public init(
		authorizationValue: String = "Bearer --Token Placeholder--"
	) {
		self.authorizationValue = authorizationValue
	}
	
	public func preprocess(
		_ target: inout some Target,
		rewriteExistedData: Bool = false
	) {
		var headers = target.headers ?? [:]
		if rewriteExistedData || headers[authorizationKey] == nil {
			headers[authorizationKey] = authorizationValue
		}
		target.headers = headers
	}
}

open class ErrorHandlerMock: ErrorHandler {
	
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

