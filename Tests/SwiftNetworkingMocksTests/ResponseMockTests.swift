//
//  ResponseMockTests.swift
//  
//
//  Created by Dmytro Chapovskyi on 21.04.2023.
//

import XCTest
import SwiftNetworkingMocks
import SwiftNetworking

final class ResponseMockTests: XCTestCase {

    func testInit_withTailFileName_DecodesCorrectResponseObject() async throws {
		
		let mock = try ResponseMock(tailFileName: "little_tail", bundle: Bundle.module)
		let host = HostMock(defaultResponseMock: mock)
		let target = DecodableTarget<SampleJsonObject>("any")
		let result = try await host.execute(target)
		print(result)
	}
	
}
