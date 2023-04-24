//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 13.04.2023.
//

import Foundation

public struct ResponseMock {

	public var body: Data
	public var error: Error?

	public init(
		_ body: Data = Data(),
		error: Error? = nil
	) {
		self.error = error
		self.body = body
	}
	
	public init(
		tailFileName: String,
		bundle: Bundle
	) throws {
		guard let url = bundle.url(forResource: tailFileName, withExtension: "tail") else {
			throw CocoaError(.fileNoSuchFile)
		}
		let data = try Data(contentsOf: url)
		guard let str = String(data: data, encoding: .utf8) else {
			throw CocoaError(.formatting)
		}
		guard let bodyStartIdx = str.range(of: "\n{")?.lowerBound else {
			throw CocoaError(.formatting)
		}
		let jsonString = String(str[bodyStartIdx...])
		
		let utf8 = jsonString.utf8
		let dataUtf8 = jsonString.data(using: .utf8)
		
		
//		let encoder = JSONEncoder()
		self.body = dataUtf8!//try encoder.encode(jsonString)
		self.error = nil
	}
}

