//
//  URLFromTargetSpec.swift
//  
//
//  Created by Dmytro Chapovskyi on 03.03.2023.
//

import XCTest
@testable import SwiftNetworking

@available(iOS 16.0, *)
final class URLFromTargetSpec: XCTestCase {

	let sampleHost = "http://sample.host"
	let sampleTarget = DummyTarget()
	
	override func setUpWithError() throws {
		
	}

	override func tearDownWithError() throws {
		
	}

	func testHostWithTrailingSlash_correctResult() {
		let request = URLRequest(host: sampleHost + "/", sampleTarget)
		validate(request: request)
	}
	
	func testTargetWithPrefixSlash_correctResult() {
		var target = sampleTarget
		target.path = "/sample/path"
		let request = URLRequest(host: sampleHost, target)
		validate(request: request)
	}
	
	func testTargetWithPrefixSlash_HostWithTrailingSlash_correctResult() {
		var target = sampleTarget
		target.path = "/sample/path"
		let request = URLRequest(host: sampleHost + "/", target)
		validate(request: request)
	}
	
	private func validate(request: URLRequest) {
		let url = request.url!
		XCTAssertEqual(url.absoluteString.ranges(of: "//").count, 1)
	}
}

struct DummyTarget: Target {

	var path = "sample/path"
	
	var method = HTTPMethod.GET
	
	var payload: Payload = .none
	
	var headers: Headers? = nil
	
	
}
