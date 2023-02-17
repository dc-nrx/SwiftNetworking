//
//  Method.swift
//  
//
//  Created by Dmytro Chapovskyi on 14.02.2023.
//

import Foundation

public enum Method: String {
	case POST, GET, PUT, PATCH, DELETE
}

public typealias Query = [String: String]

public enum ParameterEncoding {
	case nothingSpecial // to be extended in case of need
}

public typealias DownloadDestination = String
