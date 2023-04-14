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
		host: String,
		_ target: any Target
	) throws {
		guard let urlWithoutQuery = URL.makePreQueryUrl(host: host, path: target.path) else {
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
		host: String,
		path: String
	) -> URL? {
		var hostNormalized = host
		if host.last == "/" && path.first == "/" {
			hostNormalized.removeLast()
		} else if host.last != "/" && path.first != "/" {
			hostNormalized += "/"
		}
		
		return URL(string: hostNormalized + path)
	}
	
	func appending(_ query: Query?) -> URL? {
		var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)!
		urlComponents.queryItems = query?.map { URLQueryItem(name: $0, value: "\($1)") }
		urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
		return urlComponents.url
	}
}
