//
//  MockedResponseTests.swift
//  
//
//  Created by Dmytro Chapovskyi on 11.04.2023.
//

import XCTest
import SwiftNetworking
import SwiftNetworkingMocks

final class MockedResponseTests: XCTestCase {

	func testLoadMockedJson_Iphone9Info() throws {
		let data = try Data(jsonName: "Iphone9Info", bundle: .module)
		let string = String(data: data, encoding: .utf8)
		XCTAssertNotNil(data)
		XCTAssertNotNil(string?.ranges(of: "iPhone 9").first)
	}
	
	func testHostMock_returnsIphone9Info() async throws {
		let sut = HostMock()
		let path = "/sample"
		let target = DataTarget(path: path)
		let response = ResponseMock(try Data(jsonName: "Iphone9Info", bundle: .module))
		sut.mock(response, for: target)
		let data: Data = try await sut.send(target)
		XCTAssertTrue(!data.isEmpty)
	}
	
	func testHostMock_noMockedData_throwsError() async throws {
		let sut = HostMock()
		let target = DataTarget(path: "path")
		let expectation = expectation(description: "expect call to throw error")
		do {
			let _ = try await sut.send(target)
		} catch {
			if case HostMockError.noMockedDataForTarget(_) = error {
				expectation.fulfill()
			}
		}
		
		await fulfillment(of: [expectation], timeout: 0.5)
	}
}
