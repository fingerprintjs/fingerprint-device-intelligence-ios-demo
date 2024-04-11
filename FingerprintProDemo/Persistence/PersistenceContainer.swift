protocol PersistableValueKey: CaseIterable, RawRepresentable where RawValue == String {}

protocol PersistableValueCodingStrategy<Key> {

    associatedtype Key: PersistableValueKey

    func valueEncoder(forKey key: Key) -> any DataEncoder
    func valueDecoder(forKey key: Key) -> any DataDecoder
}

struct PersistenceContainer<Key: PersistableValueKey> {

    private let backingStorage: any BackingStorage
    private let codingStrategy: any PersistableValueCodingStrategy<Key>

    init(
        backingStorage: any BackingStorage,
        codingStrategy: any PersistableValueCodingStrategy<Key>
    ) {
        self.backingStorage = backingStorage
        self.codingStrategy = codingStrategy
    }

    @discardableResult
    func storeValue<Value: Encodable>(_ value: Value, forKey key: Key) -> Result<Void, any Error> {
        .init {
            let encoder = codingStrategy.valueEncoder(forKey: key)
            let data = try encoder.encode(value)
            try backingStorage.writeData(data, forKey: key.rawValue)
        }
    }

    func containsValue(forKey key: Key) -> Bool {
        backingStorage.containsData(forKey: key.rawValue)
    }

    func loadValue<Value: Decodable>(_ valueType: Value.Type = Value.self, forKey key: Key) -> Result<Value, any Error> {
        .init {
            let data = try backingStorage.readData(forKey: key.rawValue)
            let decoder = codingStrategy.valueDecoder(forKey: key)
            let value = try decoder.decode(valueType, from: data)

            return value
        }
    }

    @discardableResult
    func removeValue(forKey key: Key) -> Result<Void, any Error> {
        .init {
            try backingStorage.removeData(forKey: key.rawValue)
        }
    }

    @discardableResult
    func clear() -> Result<Void, any Error> {
        .init {
            try Key
                .allCases
                .map(\.rawValue)
                .forEach(backingStorage.removeData(forKey:))
        }
    }
}
