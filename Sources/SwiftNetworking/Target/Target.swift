import Foundation

public typealias Query = [String: CustomStringConvertible]

public typealias Headers = [String: String]

public enum HTTPMethod: String {
	case POST, GET, PUT, PATCH, DELETE
}

/// The protocol used to define the specifications necessary for a `MoyaProvider`.
public protocol Target {

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
