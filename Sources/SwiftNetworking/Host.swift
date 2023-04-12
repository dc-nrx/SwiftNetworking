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

	var requestPreprocessor: RequestPreprocessor? { get }
	var errorHandler: ErrorHandler? { get }
	var session: URLSession { get }
	var baseURLString: String { get }
	
	func request<T: Target> (
		_ target: T
	) async throws -> T.Response
}

public extension Host {

	var requestPreprocessor: RequestPreprocessor? { nil }
	var errorHandler: ErrorHandler? { nil }
	var session: URLSession { .shared }

}

/**
 Adds headers to `Target` - such as authorization, preffered language etc.
 */
public protocol RequestPreprocessor: AnyObject {
	
	func preprocess(_ target: inout some Target)
}

/**
 Can be used to handle "token expired" errors in-place.
 */
public protocol ErrorHandler {

	//TODO: Provide tools to resolve arbitrary issues (not only token expired case)
	
	/**
	 Refresh the token. (or do any other work that may fix the networking issues)
	 */
	func handle(error: Error) async throws
	
	/**
	 Depending on the `error` nature, make the decision whether the token refresh might help.
	 */
	func canHandle(error: Error) -> Bool
}
