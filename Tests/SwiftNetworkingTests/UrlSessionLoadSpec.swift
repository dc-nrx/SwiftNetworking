//
//  UrlSessionLoadSpec.swift
//  
//
//  Created by Dmytro Chapovskyi on 05.02.2023.
//

import XCTest
import SwiftNetworking

final class UrlSessionLoadSpec: XCTestCase {

	let cardsURL = URL(string: "https://api.magicthegathering.io/v1/cards?pageSize=2")!
	
	lazy var cardsResource = Target<CardsResponse>(url: cardsURL)
	
	override func setUpWithError() throws {
		 
	}

	override func tearDownWithError() throws {
		
	}

	func testLoad() async throws {
		let cards = try await NetworkServiceMock().request(cardsResource).cards
		XCTAssertEqual(cards.count, 2)
	}
	
//	func testHeadersMerge_noCollisions_allPresent() {
//		
//	}
}
