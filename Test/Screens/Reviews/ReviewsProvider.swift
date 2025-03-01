import Foundation

/// Класс для загрузки отзывов.
final class ReviewsProvider {

    private let bundle: Bundle

    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

}

// MARK: - Internal

extension ReviewsProvider {

    typealias GetReviewsResult = Result<Data, GetReviewsError>

    enum GetReviewsError: Error {

        case badURL
        case badData(Error)

    }

    func getReviews(offset: Int = 0, completion: @escaping (GetReviewsResult) -> Void) {
        guard let url = bundle.url(forResource: "getReviews.response", withExtension: "json") else {
            return completion(.failure(.badURL))
        }

        // Симулируем сетевой запрос - не менять
        usleep(.random(in: 100_000...1_000_000))

        do {
            let data = try Data(contentsOf: url)
            let allReviews = try JSONDecoder().decode(Reviews.self, from: data)
                
            let limit = 20
                
            if offset >= allReviews.items.count {
                let emptyReviews = Reviews(items: [], count: allReviews.count)
                let emptyData = try JSONEncoder().encode(emptyReviews)
                return completion(.success(emptyData))
            }
                
            let end = min(offset + limit, allReviews.items.count)
            let slice = Array(allReviews.items[offset..<end])
            let slicedReviews = Reviews(items: slice, count: allReviews.count)
            let slicedData = try JSONEncoder().encode(slicedReviews)
            return completion(.success(slicedData))
        } catch {
            return completion(.failure(.badData(error)))
        }
    }

}
