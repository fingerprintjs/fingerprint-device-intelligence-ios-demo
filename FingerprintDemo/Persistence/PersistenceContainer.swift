protocol PersistableValueKey: CaseIterable, RawRepresentable where RawValue == String {}

protocol ReadOnlyPersistenceContainer<Key>: Sendable {

    associatedtype Key: PersistableValueKey

    func containsValue(forKey key: Key) -> Bool
    func loadValue<Value: Decodable>(_ valueType: Value.Type, forKey key: Key) throws -> Value
}

extension ReadOnlyPersistenceContainer {

    func loadValue<Value: Decodable>(_ valueType: Value.Type = Value.self, forKey key: Key) throws -> Value {
        try loadValue(valueType, forKey: key)
    }
}

struct PersistenceStrategy<Key: PersistableValueKey>: Sendable {

    private let _backingStorageForKey: @Sendable (Key) -> any BackingStorage
    private let _valueEncoderForKey: @Sendable (Key) -> any DataEncoder
    private let _valueDecoderForKey: @Sendable (Key) -> any DataDecoder

    init(
        backingStorageForKey: @escaping @Sendable (Key) -> any BackingStorage,
        valueEncoderForKey: @escaping @Sendable (Key) -> any DataEncoder,
        valueDecoderForKey: @escaping @Sendable (Key) -> any DataDecoder
    ) {
        self._backingStorageForKey = backingStorageForKey
        self._valueEncoderForKey = valueEncoderForKey
        self._valueDecoderForKey = valueDecoderForKey
    }

    func backingStorage(forKey key: Key) -> any BackingStorage {
        _backingStorageForKey(key)
    }

    func valueEncoder(forKey key: Key) -> any DataEncoder {
        _valueEncoderForKey(key)
    }

    func valueDecoder(forKey key: Key) -> any DataDecoder {
        _valueDecoderForKey(key)
    }
}

struct PersistenceContainer<Key: PersistableValueKey>: ReadOnlyPersistenceContainer {

    private let persistenceStrategy: PersistenceStrategy<Key>

    init(persistenceStrategy: PersistenceStrategy<Key>) {
        self.persistenceStrategy = persistenceStrategy
    }

    func storeValue<Value: Encodable>(_ value: Value, forKey key: Key) throws {
        let encoder = persistenceStrategy.valueEncoder(forKey: key)
        let data = try encoder.encode(value)
        let backingStorage = persistenceStrategy.backingStorage(forKey: key)
        try backingStorage.writeData(data, forKey: key.rawValue)
    }

    func containsValue(forKey key: Key) -> Bool {
        let backingStorage = persistenceStrategy.backingStorage(forKey: key)
        return backingStorage.containsData(forKey: key.rawValue)
    }

    func loadValue<Value: Decodable>(_ valueType: Value.Type = Value.self, forKey key: Key) throws -> Value {
        let backingStorage = persistenceStrategy.backingStorage(forKey: key)
        let data = try backingStorage.readData(forKey: key.rawValue)
        let decoder = persistenceStrategy.valueDecoder(forKey: key)
        let value = try decoder.decode(valueType, from: data)

        return value
    }

    func removeValue(forKey key: Key) throws {
        let backingStorage = persistenceStrategy.backingStorage(forKey: key)
        try backingStorage.removeData(forKey: key.rawValue)
    }

    func clear() throws {
        try Key
            .allCases
            .forEach { key in
                try removeValue(forKey: key)
            }
    }
}
