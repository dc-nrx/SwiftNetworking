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
	
	private let host = "https://api.magicthegathering.io"
	private let apiVer = "v1"
		
	public var headers = [
		"auth": "Bearer AZAZA"
	]
	
	public init() { }
}

private extension MtgApiImpl {
	
	enum Endpoint: String {
		case cards
		case types
	}
	
	private func url(for endpoint: Endpoint) -> URL {
		URL(host: host, path: apiVer + "/" + endpoint.rawValue)
	}
}

extension MtgApiImpl: MtgAPI {
	
	public func cards(
		page: Int,
		query: Query?
	) throws -> Target<CardsResponse> {
		Target<CardsResponse>(url: url(for: .cards), method: .GET)
	}
	
	public func types() throws -> Target<TypesResponse> {
		Target<TypesResponse>(url: url(for: .types), method: .GET)
	}
}
