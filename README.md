# SwiftNetworking

SwiftNetworking is a lightweight, easy-to-use, and powerful networking library for Swift. 

It simplifies the process of making network requests and handling responses by adding minimum extra logic to the official networking tools.

## Features

- **Easy-to-use API**: Provides a simple and intuitive API for making network requests.
- **Built for Swift**: Is built specifically for Swift, leveraging Swift's modern features.
- **Fine-tuned for refactor**: Easily compatible with legacy networking components (see Sample Usage).
- **Highly customizable**: Can be customized to suit your needs, allowing for greater flexibility and control.
- **Lightweight**: The framework is based on 4 protocols, with a few very concise default implementations.

## Installation

You can install SwiftNetworking via the Swift Package Manager by adding the following line to your `Package.swift` file's dependencies:

```swift
.package(url: "https://github.com/dc-nrx/SwiftNetworking.git", from: "0.6.0")
```
## Sample Usage

The most common use case is working with `Decodable` responses:

```swift
// Declaring a host
let host = RegularHost("api.sampleapis.com")

// Adding new endpoint
let target = DecodableTarget<[Game]>("playstation/games") // Game: Decodable

// Get the decoded results
let games = try await host.execute(target)
```

## Legacy Codebase Refactor

Assuming there is some legacy `NetworkManager` class, it can be conformed to both `ErrorHandler` & `RequestPreprocessor` protocols as follows:

```swift
extension NetworkManager: ErrorHandler & RequestPreprocessor {

    public func preprocess(_ target: inout some SwiftNetworking.Target) {
        var headers = [
            "Authorization": authManager.token
            //...
        ]
        target.headers = (target.headers ?? [:]).merging(headers, uniquingKeysWith: { $1 })
    }

    public func handle(error: Error) async throws {
        if error == .tokenExpired {
            try await authManager.refreshToken()
        }
    }

    public func canHandle(error: Error) -> Bool {
        return error == .tokenExpired 
    }
}
```

and then injected to a host on initialization:

```swift
let host = RegularHost("api.sampleapis.com", requestPreprocessor: networkManager, errorHandler: networkManager)
```

This way, there will be a single source of networking-related data, eliminating any risks of inconsistency.

## Architecture

The framework is based on 2 core protocols (`Host` and `Target`), and 2 additional ones (`RequestPreprocessor` and `ErrorHandler`).

Also, it offers a few default implementations that cover the most common scenarios.

### Target

A `Target` represents an endpoint. In addition to the data necessary for making request (such as method, path, body etc.), it incapsulates the parsing logic.

The default implementations cover `Decodable`, `Data` and empty response cases.

The corresponding types are `DecodableTarget`, `DataTarget` and `PlainTarget`. They also may be used as a reference for custom `Target` types implementation.

### Host

A `Host` represents... a host. Its single function is to execute requests represented by `Target`s. In order to do so, it can use a custom URLSession. 

It also has optional `RequestPreprocessor` and `ErrorHandler`. The common use for the first is adding standard headers (such as `Authorization`) to each request. The second can be used to recover from common errors (such as expired token).

The default implementation `RegularHost` uses both of them. In case `ErrorHandler` is able to hadle an error, it is given a chanse to, and the request is re-sent once again.

`RegularHost` also provides extensive multi-level logging via the standard swift `Logger` from `OSLog` framework.

## Further plans:
- Multipart data support
- Request post-processing
- Prioritized requests queue

## License
SwiftNetworking is licensed under the MIT License.
