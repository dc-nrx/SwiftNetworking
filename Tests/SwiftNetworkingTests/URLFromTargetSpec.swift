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

	let sampleHostName = "http://sample.host"
	
	// MARK: - Slash between host and target
	
	func testHostWithTrailingSlash_correctResult() {
		let target = PlainTarget("/sample/path")
		let request = try! URLRequest(baseUrl: sampleHostName + "/", target)
		validate(request: request)
	}
	
	func testTargetWithPrefixSlash_correctResult() {
		let target = PlainTarget("/sample/path")
		let request = try! URLRequest(baseUrl: sampleHostName, target)
		validate(request: request)
	}
	
	func testTargetWithPrefixSlash_HostWithTrailingSlash_correctResult() {
		let target = PlainTarget("/sample/path")
		let request = try! URLRequest(baseUrl: sampleHostName + "/", target)
		validate(request: request)
	}
    
	// MARK: - Query
	
    func testQuery_nilValueIgnored() {
        let target = PlainTarget(
            "/sample",
            query: [
                "p1": 42,
                "p2": nil,
                "p3": "1"
            ]
        )
        let req = try! URLRequest(baseUrl: sampleHostName, target)
        let queryItems = req.url!.query()!
        print(queryItems)
        XCTAssertEqual(queryItems.components(separatedBy: "&").count, 2)
    }
    
    func testQuery_arrayIsCorrect() {
        let target = PlainTarget(
            "/sample",
            query: [
                "p1": 42,
                "p2": [1,2,3],
                "p3": "1234567"
            ]
        )
        let req = try! URLRequest(baseUrl: sampleHostName, target)
        let queryItems = req.url!.query()!
        print(queryItems)
        XCTAssertEqual(queryItems.components(separatedBy: "&").count, 5)
    }
    
//	func testQueryItems_StringValues() {
//
//	}
//
//	func testQueryItems_IntValues() {
//
//	}
//
//	func testQueryItems_FloatValues() {
//
//	}
//
//	func testQueryItems_BoolValues() {
//
//	}
	
}

// MARK: - Private
@available(iOS 16.0, *)
private extension URLFromTargetSpec {
	
	func validate(request: URLRequest) {
		let url = request.url!
		XCTAssertEqual(url.absoluteString.ranges(of: "//").count, 1)
	}
}
