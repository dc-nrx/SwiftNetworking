import Foundation

public typealias Query = [String: String]

/// Represents HTTP request payload, except for headers (various types of body, query or their combination)
public enum Payload {

    /// A request with no additional data.
    case none

	/// A requests body set with encoded parameters.
	case query(Query)

	/// A requests body set with data.
	case data(Data)

	/// A request body set with `Encodable` type.
    case encodable(Encodable)

    /// A requests body set with data, combined with url parameters.
    case composite(body: Data, query: Query)
}
