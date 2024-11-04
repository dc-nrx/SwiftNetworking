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
        if let query {
            var queryItems = [URLQueryItem]()
            for key in query.keys {
                guard let value = query[key], value != nil else { continue }
                if let collection = value as? any Collection {
                    collection.forEach {
                        queryItems.append(.init(name: "\(key)[]", value: "\($0)"))
                    }
                } else {
                    queryItems.append(.init(name: key, value: "\(value!)"))
                }
                
            }
            urlComponents.queryItems = queryItems
            urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        }
		return urlComponents.url
	}
}
