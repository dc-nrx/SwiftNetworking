//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 12.04.2023.
//

import Foundation
import SwiftSerialize

public struct DecodableTarget<T: Decodable>: Target {

	public typealias Response = T

	public var path: String
	public var method: HTTPMethod
	public var body: Data?
	public var query: Query?
	public var headers: Headers?
	
	public var responseDataMapper: ResponseDataMapper
	
	public init(
		_ path: String,
		method: HTTPMethod = .GET,
		query: Query? = nil,
		body: Data? = nil,
		headers: Headers? = nil,
		decoder: JSONDecoder = .custom()
	) {
		self.path = path
		self.method = method
		self.query = query
		self.body = body
		self.headers = headers
		responseDataMapper = { try decoder.decode(Response.self, from: $0) }
	}
}
