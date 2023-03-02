import Foundation

public typealias Query = [String: CustomStringConvertible]

/// Represents HTTP request payload, except for headers (various types of body, query or their combination)
public enum Payload {

    /// A request with no payload.
    case none

	/// Url parameters (aka query).
	case query(Query)

	/// Body set with data.
	case data(Data)

	/// Body set with `Encodable` type.
    case encodable(Encodable)

    /// A body set with data, combined with url parameters.
    case composite(body: Data, query: Query)
}
