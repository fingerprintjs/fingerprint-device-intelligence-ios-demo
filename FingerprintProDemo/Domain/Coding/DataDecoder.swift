import Foundation

public protocol DataDecoder {
    func decode<D: Decodable>(_ type: D.Type, from data: Data) throws -> D
}

extension JSONDecoder: DataDecoder {}
