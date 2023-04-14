//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 14.04.2023.
//

import Foundation

enum UrlFromTargetGenerationError: Error {
	case preQueryUrlGenerationFailed(any Target)
	case queryAppendingFailed(any Target)
}

public extension URL {
	
	init(
		baseUrl: String,
		_ target: any Target
	) throws {
		guard let urlWithoutQuery = URL.makePreQueryUrl(baseUrl: baseUrl, path: target.path) else {
			throw UrlFromTargetGenerationError.preQueryUrlGenerationFailed(target)
		}
		
		if let urlWithQuery = urlWithoutQuery.appending(target.query) {
			self = urlWithQuery
		} else {
			throw UrlFromTargetGenerationError.queryAppendingFailed(target)
		}
	}
}

private extension URL {
	
	static func makePreQueryUrl(
		baseUrl: String,
		path: String
	) -> URL? {
		var baseUrlNormalized = baseUrl
		if baseUrl.last == "/" && path.first == "/" {
			baseUrlNormalized.removeLast()
		} else if baseUrl.last != "/" && path.first != "/" {
			baseUrlNormalized += "/"
		}
		
		return URL(string: baseUrlNormalized + path)
	}
	
	func appending(
		_ query: Query?
	) -> URL? {
		var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)!
		urlComponents.queryItems = query?.map { URLQueryItem(name: $0, value: "\($1)") }
		urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
		return urlComponents.url
	}
}
