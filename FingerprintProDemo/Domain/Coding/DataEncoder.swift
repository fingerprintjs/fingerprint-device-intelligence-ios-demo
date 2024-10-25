import Foundation

public protocol DataEncoder: Sendable {
    func encode<E: Encodable>(_ value: E) throws -> Data
}

extension JSONEncoder: DataEncoder {}
