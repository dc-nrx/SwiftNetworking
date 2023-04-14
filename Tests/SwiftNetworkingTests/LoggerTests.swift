//
//  LoggerTests.swift
//  
//
//  Created by Dmytro Chapovskyi on 14.04.2023.
//

import XCTest
import SwiftNetworking
import SwiftNetworkingMocks

final class LoggerTests: XCTestCase {

	var sut: DefaultLogger!
	
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() async throws {
		let sut = DefaultLogger()
		let host = RegularHost("api.sampleapis.com", logger: sut)
		let target = DecodableTarget<Data>("playstation/games")
		try await host.send(target)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
