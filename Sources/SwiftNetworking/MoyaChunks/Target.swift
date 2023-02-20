import Foundation

public enum HTTPMethod: String {
	case POST, GET, PUT, PATCH, DELETE
}

/// The protocol used to define the specifications necessary for a `MoyaProvider`.
public protocol Target {

	associatedtype Response = ()
	typealias Parser = (Data) throws -> Response
	
    /// The target's base `URL`.
    var baseURL: URL { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    /// The HTTP method used in the request.
    var method: HTTPMethod { get }

    /// Incapsulates the parameters and instructions how to attach them (via query, body, etc.)
	var payload: Payload { get }

    /// The headers to be used in the request.
    var headers: Headers? { get set }
	
	/// The parsing closure. Has default implementations for `()` and `Decodable` response types.
	var parse: Parser { get }
}

public extension Target where Response: Decodable {
	
	var parse: Parser { { try JSONDecoder().decode(Response.self, from: $0) } }
}

public extension Target where Response == () {

	var parse: Parser { { _ in () } }
}

/// Sugar
public extension Target {
	
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
