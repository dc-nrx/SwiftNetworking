//
//  RegularHostTests.swift
//  
//
//  Created by Dmytro Chapovskyi on 15.04.2023.
//

import XCTest
@testable import SwiftNetworking

final class RegularHostTests: XCTestCase {

	var sut: RegularHost!
	
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testCreateHostWithoutVar_sendRequest_resultSuccessfullyReceived() async throws {
//		let target = DataTarget("playstation/games")
//		let data = try await RegularHost("api.sampleapis.com")
//			.execute(target)
//		let responseString = String(data: data, encoding: .utf8)!
//		XCTAssert(!responseString.isEmpty)
//    }

}
