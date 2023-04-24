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
	
	public var address: String
	
	/**
	 The default response mock. Being used for all requests not specified by `mock(_ response:, for target:)` method.
	 */
	public var defaultResponseMock: ResponseMock?
	
	private var mockedResponses = [String: ResponseMock]()

	public init(
		mockedResponses: [String: ResponseMock] = [String: ResponseMock](),
		address: String = "__MOCK__",
		defaultResponseMock: ResponseMock? = nil
	) {
		self.address = address
		self.mockedResponses = mockedResponses
		self.defaultResponseMock = defaultResponseMock
	}

	public func execute<T>(_ target: T) async throws -> T.Response where T : Target {
		let mockedResponse: ResponseMock
		if let specificResponse = mockedResponses[key(for: target)] {
			mockedResponse = specificResponse
		} else if let defaultResponseMock = defaultResponseMock {
			mockedResponse = defaultResponseMock
		} else {
			throw HostMockError.noMockedDataForTarget(target)
		}
		
		if let error = mockedResponse.error {
			throw error
		} else {
			return try target.responseDataMapper(mockedResponse.body)
		}
	}
		
	public func mock(_ response: ResponseMock, for target: any Target) {
		mockedResponses[key(for: target)] = response
	}
	
	private func key(for target: any Target) -> String {
		target.description
	}
}
