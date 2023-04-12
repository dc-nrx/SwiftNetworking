//
//  PublicApiHostMock.swift
//  
//
//  Created by Dmytro Chapovskyi on 09.04.2023.
//

import Foundation
import SwiftNetworking

public enum HostMockError: Error {
	case noMockedDataForTarget(any Target)
}

public class HostMock: SwiftNetworking.Host {
	
	public var requestPreprocessor: RequestPreprocessor?
	public var errorHandler: ErrorHandler?
	public var baseURLString: String

	public var mockedResponses = [String: Data]()
	
	public init(
		mockedResponses: [String: Data] = [String: Data](),
		requestPreprocessor: RequestPreprocessor? = nil,
		authorizationHandler: ErrorHandler? = nil,
		baseURLString: String = "__MOCK__//"
	) {
		self.requestPreprocessor = requestPreprocessor
		self.errorHandler = authorizationHandler
		self.baseURLString = baseURLString
	}

	public func request<T>(_ target: T) async throws -> T.Response where T : Target {
		guard let data = mockedResponses[target.path] else {
			throw HostMockError.noMockedDataForTarget(target)
		}
		return try target.parse(data)
	}
}
