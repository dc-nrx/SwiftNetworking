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
		sut.mockedResponses[path] = try Data(jsonName: "Iphone9Info", bundle: .module)
		let target = DataTarget(path: path)
		let data: Data = try await sut.send(target)
		XCTAssertNotNil(data)
	}
	
	func testHostMock_noMockedData_throwsError() async throws {
		let sut = HostMock()
		let target = DataTarget(path: "path")
		let expectation = expectation(description: "expect call to throw error")
		do {
			let _ = try await sut.send(target)
		} catch {
			if case HostMockError.noMockedDataForTarget(let errTarget) = error {
				expectation.fulfill()
			}
		}
		
		wait(for: [expectation], timeout: 0.5)
	}
}
