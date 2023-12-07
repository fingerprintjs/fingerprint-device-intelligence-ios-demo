extension String {

    var linesCount: Int {
        components(separatedBy: .newlines).count
    }
}
