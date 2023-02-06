//
//  API.swift
//  
//
//  Created by Dmytro Chapovskyi on 06.02.2023.
//

import Foundation
import SwiftNetworking

public protocol MtgAPI {
	func cards(page: Int, query: Query?) throws -> Target<CardsResponse>
}

public final class MtgApiImpl: MtgAPI {
	
	private let host = "https://api.magicthegathering.io"
	private let apiVer = "v1"
	
	private let cardsPath = "cards?pageSize=2"
	
	public init() { }
	
	public func cards(
		page: Int,
		query: Query?
	) throws -> Target<CardsResponse> {
		Target<CardsResponse>(
			url: URL(string: "https://api.magicthegathering.io/v1/cards?pageSize=2")!
		)
	}
}

public struct CardsResponse: Decodable {
	public let cards: [Card]
}

public struct Card: Decodable {
		
	public let name: String
	public let id: String
	public let imageUrl: String?
}
