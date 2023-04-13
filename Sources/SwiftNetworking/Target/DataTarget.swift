//
//  File.swift
//
//
//  Created by Dmytro Chapovskyi on 12.04.2023.
//

import Foundation

public struct DataTarget: Target {
		
	public typealias Response = Data

	public var path: String
	public var method: HTTPMethod
	public var body: Data?
	public var query: Query?
	public var headers: Headers?
	
	public var decode: (Data) throws -> Response = { $0 }
	
	public init(
		path: String,
		method: HTTPMethod = .GET,
		query: Query? = nil,
		body: Data? = nil,
		headers: Headers? = nil
	) {
		self.path = path
		self.method = method
		self.query = query
		self.body = body
		self.headers = headers
	}
}
