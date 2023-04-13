//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 13.04.2023.
//

import XCTest
import SwiftNetworking
import SwiftNetworkingMocks

final class HostMockTests: XCTestCase {
	
	var sut: HostMock!
	
	override func setUp() async throws {
		sut = HostMock()
	}

	override func tearDown() async throws {
		sut = nil
	}

	func testReturnsDefaultMockResponse() async throws {
		let responseMock = ResponseMock(Data([1,2,3]))
		sut.defaultResponseMock = responseMock
		let responseData = try await sut.send(DataTarget("xxx"))
		XCTAssertEqual(responseData, responseMock.body)
	}
	
	func testReturnsSpecificMockResponse_defaultMockResponseNil() async throws {
		let specificResponseMock = ResponseMock(Data([1,2,3]))
		let target = DataTarget("xxx")
		sut.defaultResponseMock = nil
		sut.mock(specificResponseMock, for: target)
		let responseData = try await sut.send(target)
		XCTAssertEqual(responseData, specificResponseMock.body)
	}
	
	func testReturnsSpecificMockResponse_defaultMockResponseNotNil() async throws {
		let specificResponseMock = ResponseMock(Data([1,2,3]))
		let target = DataTarget("xxx")
		sut.mock(specificResponseMock, for: target)
		sut.defaultResponseMock = ResponseMock(Data([7,7,7]))
		let responseData = try await sut.send(target)
		XCTAssertEqual(responseData, specificResponseMock.body)
	}

	func testSpecificMockSet_returnsDefaultReponseMock_forAnotherTarget() async throws {
		let specificResponseMock = ResponseMock(Data([1,2,3]))
		let defaultResponseMock = ResponseMock(Data([7,7,7]))
		let target = DataTarget("xxx")
		sut.mock(specificResponseMock, for: target)
		sut.defaultResponseMock = ResponseMock(Data([7,7,7]))
		let anotherTarget = DataTarget("zzz")
		let responseData = try await sut.send(anotherTarget)
		XCTAssertEqual(responseData, defaultResponseMock.body)
	}

	func test3SpecificMocksSet_returnsCorrectValues_forCorrespondingTargets() async throws {
		let pairs = (0...3).map { (target: DataTarget("\($0)"), responseMock: ResponseMock(Data([$0]))) }
		for (target, response) in pairs {
			sut.mock(response, for: target)
		}
		for (target, responseMock) in pairs {
			let resposeData = try await sut.send(target)
			XCTAssertEqual(resposeData, responseMock.body)
		}
	}
}
