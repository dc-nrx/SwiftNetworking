import Foundation

public typealias QueryItem = CustomStringConvertible

public typealias Query = [String: QueryItem]

public typealias Headers = [String: String]

public enum HTTPMethod: String {
	case POST, GET, PUT, PATCH, DELETE
}

/// The protocol used to define the specifications necessary for a `MoyaProvider`.
public protocol Target: CustomStringConvertible, CustomDebugStringConvertible {

	associatedtype Response = ()
	typealias DecoderFunction = (Data) throws -> Response
	
	/// Target path - i.e. the part of url AFTER host address.
    var path: String { get set }
	
	var method: HTTPMethod { get set }
	var query: Query? { get set }
	var body: Data? { get set }
	var headers: Headers? { get set }
	
	/// The parsing closure. Has default implementations for `()` and `Decodable` response types.
	var decode: DecoderFunction { get }
}

public extension Target {
	
	var description: String {
		var queryString = ""
		if let query = query {
			for (key, value) in query {
				queryString += key + "=" + value.description
			}
		}
		
		var bodySuffixString = ""
		if let body = body {
			bodySuffixString = " ## bodyHash = \(body.hashValue)"
		}
		
		var headersNewLine = ""
		if let headers = headers {
			headersNewLine = " ↓\nHeaders = \(headers)"
		}
		
		return method.rawValue + " " + path + "?" + queryString + bodySuffixString + headersNewLine
	}
	
	var debugDescription: String {
		return description
	}
}
