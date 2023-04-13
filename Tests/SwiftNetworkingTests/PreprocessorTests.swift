//
//  PreprocessorAndErrorHandlerTests.swift
//  
//
//  Created by Dmytro Chapovskyi on 13.04.2023.
//

import XCTest
import SwiftNetworkingMocks
import SwiftNetworking

final class RequestPreprocessorMockTests: XCTestCase {
	
	let sampleAuthValue = "test auth"
	var sut: RequestPreprocessorMock!
	
	override func setUp() async throws {
		sut = RequestPreprocessorMock(authorizationValue: sampleAuthValue)
	}
	
	override func tearDown() async throws {
		sut = nil
	}
	
    func testTargetWithNilHeaders_authHeaderAdded() throws {
		var target = DataTarget("xxx")
		sut.preprocess(&target)
		XCTAssertEqual(target.headers?[sut.authorizationKey], sampleAuthValue)
    }

	func testTargetWithEmptyNonNilHeaders_authHeaderAdded() throws {
		var target = DataTarget("xxx", headers: [:])
		sut.preprocess(&target)
		XCTAssertEqual(target.headers?[sut.authorizationKey], sampleAuthValue)
	}
	
	func testTargetWithPrefilledAuthValue_rewriteFalse_authValueNotRewritten() throws {
		let customAuthValue = "custom auth value"
		var target = DataTarget("xxx", headers: [sut.authorizationKey: customAuthValue])
		sut.preprocess(&target,rewriteExistedData: false)
		XCTAssertEqual(target.headers?[sut.authorizationKey], customAuthValue)
	}
	
	func testTargetWithPrefilledAuthValue_rewriteTrue_authValueRewritten() throws {
		let customAuthValue = "custom auth value"
		var target = DataTarget("xxx", headers: [sut.authorizationKey: customAuthValue])
		sut.preprocess(&target, rewriteExistedData: true)
		XCTAssertEqual(target.headers?[sut.authorizationKey], sampleAuthValue)
	}
}
