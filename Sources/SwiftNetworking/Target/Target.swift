import Foundation

public typealias QueryItem = CustomStringConvertible

public typealias Query = [String: QueryItem]

public typealias Headers = [String: String]

public enum HTTPMethod: String {
	case POST, GET, PUT, PATCH, DELETE
}

/// The main model item used a source to create url request.
public protocol Target: CustomStringConvertible {

	associatedtype Response = ()
	typealias ResponseDataMapper = (Data) throws -> Response
	
	/// Target path - i.e. the part of url AFTER host address.
	var path: String { get set }
	
	var method: HTTPMethod { get set }
	var query: Query? { get set }
	var body: Data? { get set }
	var headers: Headers? { get set }
	
	/// The parsing closure. Has default implementation in `DecodableTarget`,  `DataTarget` and `PlainTarget`.
	var mapResponseData: ResponseDataMapper { get }
}
 
