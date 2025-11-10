import Foundation
import Combine

final class SearchViewModel: ObservableObject {
    @Published var query: String = "" {
        didSet { performSearch() }
    }
    @Published private(set) var results: [Listing] = PreviewData.listings

    private let searchService: SearchService

    init(searchService: SearchService = SemanticSearchService()) {
        self.searchService = searchService
    }

    func performSearch() {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            results = PreviewData.listings
            return
        }
        results = searchService.search(trimmed, within: PreviewData.listings)
    }
}
