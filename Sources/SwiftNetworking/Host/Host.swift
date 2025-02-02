//
//  NetworkService.swift
//  
//
//  Created by Dmytro Chapovskyi on 05.02.2023.
//

import Foundation

/**
 The main protocol for sending requests / parsing responses. Has default implementation that handles request signing (and subsequent request re-sending if appropriate).
 */
public protocol Host {

	var protocolName: String { get }
	var address: String { get }
	
	var requestPreprocessor: RequestPreprocessor? { get }
	var errorHandler: ErrorHandler? { get }
	
	func execute<T: Target> (
		_ target: T
	) async throws -> T.Response
}

public extension Host {

	var protocolName: String { "https" }
	
	var requestPreprocessor: RequestPreprocessor? { nil }
	var errorHandler: ErrorHandler? { nil }
}

/**
 Alter a `target` before sending it - e.g. add authorization header, specify preffered language etc.
 */
public protocol RequestPreprocessor: AnyObject {
	
	func preprocess(
		_ target: inout some Target,
		rewriteExistedData: Bool
	) throws
}

public extension RequestPreprocessor {
	
	func preprocess(
		_ target: inout some Target
	) throws {
		try preprocess(&target, rewriteExistedData: false)
	}
}

/**
 Can be used to handle "token expired" errors in-place.
 */
public protocol ErrorHandler {

    /**
     Refresh token, or do any other job needed.
     */
    func prepareForExecution<T: Target>(_ target: T) async throws
    
	/**
	 Try to handle the error (i.e. refresh token for token expired / unauthorized case)
	 */
	func handle(error: Error) async throws
	
	/**
	 Depending on the `error` nature, make the decision whether there is a way to fix it (and maybe re-send the request once again).
	 */
	func canHandle(error: Error) -> Bool
}

public extension ErrorHandler {
    func prepareForExecution<T: Target>(_ target: T) async throws { }
    
    func canHandle(error: Error) -> Bool {
        switch error {
        case let RegularHostError.httpStatusError(_, httpResponse):
            httpResponse.statusCode == 401
        default:
            false
        }
    }
}

//TODO: Add ResponsePreprocessor
