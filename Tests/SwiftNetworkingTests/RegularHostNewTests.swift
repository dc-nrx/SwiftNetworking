//
//  Test.swift
//  SwiftNetworking
//
//  Created by Dmytro Chapovskyi on 16.01.2025.
//

import Testing
import Foundation
import SwiftNetworking
import SwiftNetworkingMocks

struct TestError: Error, Equatable {
    var id = UUID()
}

class Test {

    @Test func prepareForExecution_holdsRequests() async throws {
        let sut = RegularHostMock()
        var ready = false
        sut.errorHandlerMock.prepForExec = { _ in
            if !ready {
                try await Task.sleep(for: .seconds(1))
                ready = true
            }
        }
        let t1 = PlainTarget("1")
        let t2 = PlainTarget("2")
        
        try await sut.execute(t1)
        #expect(ready == true)
        try await sut.execute(t2)
        #expect(ready == true)
    }

    @Test func prepareForExecution_error_allRequestsFail() async throws {
        let sut = RegularHostMock()
        let err = TestError()
        sut.errorHandlerMock.prepForExec = { _ in
            try await Task.sleep(for: .seconds(0.7))
            throw err
        }
        await #expect(throws: err) {
            try await sut.execute(PlainTarget("0"))
        }

        try await confirmation(expectedCount: 2) { conf in
            Task {
                await #expect(throws: err) {
                    try await sut.execute(PlainTarget("1"))
                }
                conf.confirm()
            }
            
            Task {
                await #expect(throws: err) {
                    try await sut.execute(PlainTarget("2"))
                }
                conf.confirm()
            }
            try await Task.sleep(for: .seconds(1))
        }
    }
}
