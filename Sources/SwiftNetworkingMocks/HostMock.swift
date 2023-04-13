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

	private var mockedResponses = [String: ResponseMock]()
	
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

	public func send<T>(_ target: T) async throws -> T.Response where T : Target {
		guard let response = mockedResponses[key(for: target)] else {
			throw HostMockError.noMockedDataForTarget(target)
		}
		
		if let error = response.error {
			throw error
		} else {
			return try target.decode(response.body)
		}
	}
	
	public func mock(_ response: ResponseMock, for target: any Target) {
		mockedResponses[key(for: target)] = response
	}
	
	private func key(for target: any Target) -> String {
		target.description
	}
}
