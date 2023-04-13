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
}

