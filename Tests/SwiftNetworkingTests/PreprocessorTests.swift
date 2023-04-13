//
//  PreprocessorAndErrorHandlerTests.swift
//  
//
//  Created by Dmytro Chapovskyi on 13.04.2023.
//

import XCTest
import SwiftNetworkingMocks

final class RequestPreprocessorMockTests: XCTestCase {

	var hostMock: HostMock!
	var sut: RequestPreprocessorMock!
	
    override func setUpWithError() throws {
        sut = RequestPreprocessorMock()
		hostMock = HostMock()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
