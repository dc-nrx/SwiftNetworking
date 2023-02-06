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
	func types() throws -> Target<TypesResponse>
}

public final class MtgApiImpl: NetworkService, HeadersProvider {
	
	typealias Endpoint = String
	
	private let host = "https://api.magicthegathering.io"
	private let apiVer = "v1"
	
	// Endpoint paths
	private let cardsPath: Endpoint = "cards"
	private let typesPath: Endpoint = "types"
	
	public var headers = [
		"auth": "Bearer AZAZA"
	]
	
	public init() { }
	
	private func url(for endpoint: Endpoint) -> URL {
		URL(host: host, path: apiVer + "/" + endpoint)
	}
}

extension MtgApiImpl: MtgAPI {
	
	public func cards(
		page: Int,
		query: Query?
	) throws -> Target<CardsResponse> {
		Target<CardsResponse>(url: url(for: cardsPath), method: .GET)
	}
	
	public func types() throws -> Target<TypesResponse> {
		Target<TypesResponse>(url: url(for: typesPath), method: .GET)
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

public struct TypesResponse: Decodable {
	
	public let types: [String]
}
