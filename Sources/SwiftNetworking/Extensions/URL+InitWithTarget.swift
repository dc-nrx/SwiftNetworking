//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 14.04.2023.
//

import Foundation

public extension URL {
	
	init?(
		host: String,
		_ target: any Target
	) {
		// Process double- and no-slash cases between host and target
		var hostNormalized = host
		if host.last == "/" && target.path.first == "/" {
			hostNormalized.removeLast()
		} else if host.last != "/" && target.path.first != "/" {
			hostNormalized += "/"
		}
		
		// Append query
		let urlWithoutQuery = URL(string: hostNormalized + target.path)!
		var urlComponents = URLComponents(url: urlWithoutQuery, resolvingAgainstBaseURL: false)!
		urlComponents.queryItems = target.query?.map { URLQueryItem(name: $0, value: "\($1)") }
		urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
		
		if let urlWithQuery = urlComponents.url {
			self = urlWithQuery
		} else {
			return nil
		}
	}

}
