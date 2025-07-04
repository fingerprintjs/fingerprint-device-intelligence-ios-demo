import Foundation

struct JSONSyntaxHighlighter {

    private let json: String
    private let jsonTokenizer: JSONTokenizer

    init(json: String) {
        self.json = json
        self.jsonTokenizer = JSONTokenizer(json: json)
    }

    func highlighted() -> AttributedString {
        var highlightedJSON = AttributedString(json)
        var previousToken: JSONTokenizer.Token?
        while let token = jsonTokenizer.nextToken() {
            if let previousToken,
                previousToken.type.isPropertyValue,
                token.type.isPropertyValueTerminator,
                let propertyValueRange = Range(
                    previousToken.range,
                    in: highlightedJSON
                )
            {
                highlightedJSON[propertyValueRange].foregroundColor = .accent
            }
            previousToken = token
        }
        return highlightedJSON
    }
}

private final class JSONTokenizer {

    enum TokenType: Equatable {
        case blockStart
        case blockEnd
        case arrayStart
        case arrayEnd
        case literal
        case string
        case comma
        case colon

        var isPropertyValue: Bool {
            [.literal, .string].contains(self)
        }

        var isPropertyValueTerminator: Bool {
            [.blockEnd, .arrayEnd, .comma].contains(self)
        }
    }

    struct Token {
        let type: TokenType
        let range: Range<String.Index>
    }

    private enum State {
        case start
        case string(index: String.Index)
        case literal(index: String.Index)
    }

    private let curlyBracketOpen: Character = "{"
    private let curlyBracketClose: Character = "}"
    private let squareBracketOpen: Character = "["
    private let squareBracketClose: Character = "]"
    private let comma: Character = ","
    private let colon: Character = ":"
    private let quote: Character = "\""
    private let escape: Character = "\\"
    private let literalSeparators: CharacterSet

    private let json: String
    private var index: String.Index
    private var state: State = .start
    private var isStringEscapeSequence = false

    init(json: String) {
        self.json = json
        self.index = json.startIndex
        self.literalSeparators = CharacterSet(
            charactersIn: String([
                curlyBracketOpen,
                curlyBracketClose,
                squareBracketOpen,
                squareBracketClose,
                comma,
                colon,
                quote,
            ])
        ).union(.whitespacesAndNewlines)
    }

    func nextToken() -> Token? {
        while index < json.endIndex {
            let currentIndex = index
            let character = json[currentIndex]
            let currentCharacterSet = CharacterSet(charactersIn: String(character))
            index = json.index(after: index)
            switch state {
            case .start:
                guard !currentCharacterSet.isSubset(of: .whitespacesAndNewlines) else { continue }
                switch character {
                case curlyBracketOpen:
                    return Token(type: .blockStart, range: currentIndex ..< index)
                case curlyBracketClose:
                    return Token(type: .blockEnd, range: currentIndex ..< index)
                case squareBracketOpen:
                    return Token(type: .arrayStart, range: currentIndex ..< index)
                case squareBracketClose:
                    return Token(type: .arrayEnd, range: currentIndex ..< index)
                case comma:
                    return Token(type: .comma, range: currentIndex ..< index)
                case colon:
                    return Token(type: .colon, range: currentIndex ..< index)
                case quote:
                    state = .string(index: currentIndex)
                default:
                    state = .literal(index: currentIndex)
                }
            case .literal(let literalIndex):
                if currentCharacterSet.isSubset(of: literalSeparators) {
                    index = currentIndex
                    state = .start
                    return Token(type: .literal, range: literalIndex ..< currentIndex)
                }
            case .string(let stringIndex):
                if isStringEscapeSequence {
                    isStringEscapeSequence = false
                } else if character == escape {
                    isStringEscapeSequence = true
                } else if character == quote {
                    state = .start
                    return Token(type: .string, range: stringIndex ..< index)
                }
            }
        }
        return nil
    }
}
