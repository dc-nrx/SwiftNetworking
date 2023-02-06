//
//  UrlSessionLoadSpec.swift
//  
//
//  Created by Dmytro Chapovskyi on 05.02.2023.
//

import XCTest
import SwiftNetworking

final class UrlSessionLoadSpec: XCTestCase {

	var mtgApi: MtgApiImpl!
	
	override func setUpWithError() throws {
		 mtgApi = MtgApiImpl()
	}

	override func tearDownWithError() throws {
		mtgApi = nil
	}

	func testLoad_100Cards() async throws {
		let request = try mtgApi.cards(query: nil)
		let cards = try await mtgApi.request(request).cards
		XCTAssertEqual(cards.count, 100)
	}
	
	func testLoad_Types() async throws {
		let request = try mtgApi.types()
		let cards = try await mtgApi.request(request).types
		XCTAssertEqual(cards.count, 28)
	}
}
