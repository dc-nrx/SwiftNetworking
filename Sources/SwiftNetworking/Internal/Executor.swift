//
//  Executor.swift
//  SwiftNetworking
//
//  Created by Dmytro Chapovskyi on 12.12.2024.
//

import Foundation

enum Executor {
    case session(URLSession)
    case closure(RegularHost.RequestClosure)
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        switch self {
        case .session(let urlSession):
            try await urlSession.data(for: request)
        case .closure(let closure):
            try await closure(request)
        }
    }
}
