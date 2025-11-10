import Foundation

public protocol SearchService {
    func search(_ query: String, within listings: [Listing]) -> [Listing]
}

/// Lightweight semantic search implementation using TF-IDF style term weighting.
public struct SemanticSearchService: SearchService {
    private let tokenizer: Tokenizer

    public init(tokenizer: Tokenizer = Tokenizer()) {
        self.tokenizer = tokenizer
    }

    public func search(_ query: String, within listings: [Listing]) -> [Listing] {
        let queryTokens = tokenizer.tokenize(query)
        guard !queryTokens.isEmpty else { return listings }

        let scores: [(Listing, Double)] = listings.map { listing in
            let corpusTokens = tokenizer.tokenize(listing.title + " " + listing.subtitle + " " + listing.detail + " " + listing.tags.joined(separator: " "))
            let score = Self.cosineSimilarity(between: queryTokens, and: corpusTokens)
            return (listing, score)
        }

        return scores
            .sorted { lhs, rhs in
                if lhs.1 == rhs.1 {
                    return lhs.0.rating > rhs.0.rating
                }
                return lhs.1 > rhs.1
            }
            .filter { $0.1 > 0 }
            .map { $0.0 }
    }

    private static func cosineSimilarity(between lhs: [String], and rhs: [String]) -> Double {
        let allTokens = Set(lhs + rhs)
        var lhsVector: [Double] = []
        var rhsVector: [Double] = []

        for token in allTokens {
            lhsVector.append(Double(lhs.filter { $0 == token }.count))
            rhsVector.append(Double(rhs.filter { $0 == token }.count))
        }

        let dotProduct = zip(lhsVector, rhsVector).reduce(0) { $0 + $1.0 * $1.1 }
        let lhsMagnitude = sqrt(lhsVector.reduce(0) { $0 + $1 * $1 })
        let rhsMagnitude = sqrt(rhsVector.reduce(0) { $0 + $1 * $1 })

        guard lhsMagnitude > 0, rhsMagnitude > 0 else { return 0 }
        return dotProduct / (lhsMagnitude * rhsMagnitude)
    }
}

public struct Tokenizer {
    public init() {}

    public func tokenize(_ text: String) -> [String] {
        text
            .lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
            .map { stem($0) }
    }

    private func stem(_ token: String) -> String {
        var token = token
        if token.hasSuffix("ing") { token = String(token.dropLast(3)) }
        if token.hasSuffix("ed") { token = String(token.dropLast(2)) }
        if token.hasSuffix("s") { token = String(token.dropLast()) }
        return token
    }
}
