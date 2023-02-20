import Foundation

//public enum TargetParser

/// The protocol used to define the specifications necessary for a `MoyaProvider`.
public protocol TargetType {

	associatedtype Response = ()
	typealias Parser = (Data) throws -> Response
	
    /// The target's base `URL`.
    var baseURL: URL { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    /// The HTTP method used in the request.
    var method: Method { get }

    /// Incapsulates the parameters and instructions how to attach them (via query, body, etc.)
	var payload: Payload { get }

    /// The type of validation to perform on the request. Default is `.none`.
    var validationType: ValidationType { get }

    /// The headers to be used in the request.
    var headers: Headers? { get set }
	
	/// The parsing closure. Has default implementations for `()` and `Decodable` response types.
	var parse: Parser { get }
}

public extension TargetType {

    /// The type of validation to perform on the request. Default is `.none`.
    var validationType: ValidationType { .none }
	
}

public extension TargetType where Response: Decodable {
	
	var parse: Parser { { try JSONDecoder().decode(Response.self, from: $0) } }
}

public extension TargetType where Response == () {

	var parse: Parser { { _ in () } }
}

/// Sugar
public extension TargetType {
	
	var url: URL {
		URL(string: baseURL.absoluteString + "/" + path)!
	}
	
	var query: Query? {
		switch payload {
		case .query(let query),
				.composite(_, let query):
			return query
		default:
			return nil
		}
	}
}
