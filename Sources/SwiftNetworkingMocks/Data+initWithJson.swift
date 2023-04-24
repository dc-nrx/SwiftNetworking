//
//  Data+initWithJson.swift
//  
//
//  Created by Dmytro Chapovskyi on 11.04.2023.
//

import Foundation

public extension Data {
	
	/**
	 From a package, set bundle to `Bundle.module`.
	 */
	init(
		jsonName: String,
		bundle: Bundle
	) throws {
		guard let url = bundle.url(forResource: jsonName, withExtension: "json") else {
			throw CocoaError(.fileNoSuchFile)
		}
		self = try Data(contentsOf: url)
	}
}

