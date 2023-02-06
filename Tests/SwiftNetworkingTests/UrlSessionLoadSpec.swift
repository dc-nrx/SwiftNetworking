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
		let target = try mtgApi.cards(page: 0, query: nil)
		let cards = try await mtgApi.request(target).cards
		XCTAssertEqual(cards.count, 100)
	}
	
	func testLoad_Types() async throws {
		let target = try mtgApi.types()
		let cards = try await mtgApi.request(target).types
		XCTAssertEqual(cards.count, 28)
	}
}
