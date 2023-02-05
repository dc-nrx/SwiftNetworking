//
//  Card.swift
//  MtgOrganizer
//
//  Created by Dmytro Chapovskyi on 01.02.2023.
//

import Foundation

struct CardsResponse: Decodable {
	let cards: [Card]
}

struct Card: Decodable {
		
	public let name: String
	public let id: String
	public let imageUrl: String?
}
