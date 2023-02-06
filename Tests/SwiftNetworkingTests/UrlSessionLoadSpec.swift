//
//  UrlSessionLoadSpec.swift
//  
//
//  Created by Dmytro Chapovskyi on 05.02.2023.
//

import XCTest
import SwiftNetworking

final class UrlSessionLoadSpec: XCTestCase {

	let mtgApi = MtgApiImpl()
	
	override func setUpWithError() throws {
		 
	}

	override func tearDownWithError() throws {
		
	}

	func testLoad() async throws {
		let target = try mtgApi.cards(page: 0, query: nil)
		let cards = try await NetworkServiceMock().request(target).cards
		XCTAssertEqual(cards.count, 2)
	}
	
}
