extension String {

    static func placeholder(length: Int) -> Self {
        .init(repeating: "X", count: length)
    }
}
