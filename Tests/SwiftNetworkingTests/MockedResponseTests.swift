//
//  MockedResponseTests.swift
//  
//
//  Created by Dmytro Chapovskyi on 11.04.2023.
//

import XCTest
import SwiftNetworkingMocks

final class MockedResponseTests: XCTestCase {

	override func setUpWithError() throws {
		
	}

	override func tearDownWithError() throws {
		
	}

	func testLoadMockedJson_Iphone9Info() throws {
		let data = try Data(jsonName: "Iphone9Info", bundle: .module)
		let string = String(data: data, encoding: .utf8)
		XCTAssertNotNil(data)
		XCTAssertNotNil(string?.ranges(of: "iPhone 9").first)
	}	
}
