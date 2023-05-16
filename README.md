# SwiftNetworking

SwiftNetworking is a lightweight, easy-to-use, and powerful networking library for Swift. It simplifies the process of making network requests and handling responses.

## Features

- **Easy-to-use API**: SwiftNetworking provides a simple and intuitive API for making network requests.
- **Built for Swift**: SwiftNetworking is built specifically for Swift, leveraging Swift's modern features.
- **Highly customizable**: SwiftNetworking can be customized to suit your needs, allowing for greater flexibility and control.
- **Light-weight**: The framework is based on 4 protocols, with a few very concise default implementations.

## Installation

Here's how you can add SwiftNetworking to your Swift project.

### Swift Package Manager

You can install SwiftNetworking via the Swift Package Manager by adding the following line to your `Package.swift` file's dependencies:

```swift
.package(url: "https://github.com/dc-nrx/SwiftNetworking.git", from: "0.4.0")
```
## Sample Usage

```swift
// Declaring a host:
let host = RegularHost("api.sampleapis.com")

// Adding new endpoint:
let target = DecodableTarget<[Game]>("playstation/games") // Game: Decodable

// Get the decoded results:
let games = try await host.execute(target)
```

## Architecture

The framework is based on 2 core protocols (`Host` and `Target`), and 2 additional ones (`RequestPreprocessor` and `ErrorHandler`). Also, it offers a few default implementations that cover the most common scenarios.

### Target

A `Target` represents an endpoint. In addition to the data necessary for making request (such as method, path, body etc.), it incapsulates the parsing logic.
The default implementations cover `Decodable`, `Data` and empty response cases.
The corresponding types are `DecodableTarget`, `DataTarget` and `PlainTarget`. They also may be used as a reference for custom `Target` types implementation.

### Host

A `Host` represents... well, a host. It's single function is to execute requests represented by `Target`s. In order to do so, it can use a custom URLSession. 
It also has optional `RequestPreprocessor` and `ErrorHandler`. The common use for the first is adding common headers (such as `Authorization`) to each request. The second can be used to recover from common errors (such as refresh of expired token).
The default implementation `RegularHost` uses both of them. In case `ErrorHandler` is able to hadle an error, it is given a chanse to do so, and the request is re-sent once again.
`RegularHost` also provides extensive multi-level logging. The default light-weigh logger does the job well enough, but should you need to use a more serious solution - it can be conformed to a single-method protocol and injected via `RegularHost` initializer.

## Further plans:
- Multipart data support
