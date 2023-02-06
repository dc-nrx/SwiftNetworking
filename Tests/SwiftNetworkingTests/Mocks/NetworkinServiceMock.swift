//
//  NetworkinServiceMock.swift
//  
//
//  Created by Dmytro Chapovskyi on 05.02.2023.
//

import Foundation
import SwiftNetworking

class NetworkServiceMock: NetworkService, HeadersProvider {
	
	var headers = [
		"auth": "azaza"
	]
	
}
