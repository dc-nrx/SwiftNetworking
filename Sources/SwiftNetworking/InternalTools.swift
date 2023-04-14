//
//  Tools.swift
//  
//
//  Created by Dmytro Chapovskyi on 06.02.2023.
//

import Foundation

internal extension Array {
	
	func appending(_ newElement: Element) -> Self {
		var result = self
		result.append(newElement)
		return result
	}
}

internal func == (lhs: Error, rhs: Error) -> Bool {
	guard type(of: lhs) == type(of: rhs) else { return false }
	let error1 = lhs as NSError
	let error2 = rhs as NSError
	return error1.domain == error2.domain && error1.code == error2.code && "\(lhs)" == "\(rhs)"
}

internal extension Equatable where Self : Error {
	static func == (lhs: Self, rhs: Self) -> Bool {
		lhs as Error == rhs as Error
	}
}
