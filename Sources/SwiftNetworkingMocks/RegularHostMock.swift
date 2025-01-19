//
//  RegularHostMock.swift
//  SwiftNetworking
//
//  Created by Dmytro Chapovskyi on 16.01.2025.
//

import Foundation
import SwiftNetworking

public final class RegularHostMock: RegularHost {
    
    public var preprocessorMock: RequestPreprocessorMock { requestPreprocessor as! RequestPreprocessorMock }
    public var errorHandlerMock: ErrorHandlerMock { errorHandler as! ErrorHandlerMock }
    
    public override init(
        protocolName: String = "https",
        _ address: String = "sample",
        requestPreprocessor: (any RequestPreprocessor)? = RequestPreprocessorMock(),
        errorHandler: (any ErrorHandler)? = ErrorHandlerMock(),
        requestClosure: @escaping RegularHost.RequestClosure = { _ in (Data(), URLResponse()) }
    ) {
        super.init(protocolName: protocolName, address, requestPreprocessor: requestPreprocessor, errorHandler: errorHandler, requestClosure: requestClosure)
    }
}
