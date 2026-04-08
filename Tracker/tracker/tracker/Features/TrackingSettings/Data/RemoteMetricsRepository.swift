import Foundation

final class RemoteMetricsRepository: MetricsRepository {
    private let networkClient: NetworkClient
    private let endpoint = URL(string: "https://dummyjson.com/products")!

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func fetchTrackingProfile(userId: UserID) async throws -> TrackingProfile {
        let response: ProductsResponseDTO = try await networkClient.get(endpoint)
        let products = response.products

        let tags = Array(Set(products.map(\.category)))
            .sorted()
            .map { category in
                MetricTag(
                    id: category,
                    title: category.capitalized,
                    isSystem: false
                )
            }

        let metrics = products.map { product in
            TrackedMetric(
                id: String(product.id),
                title: product.title,
                unit: "$",
                tagId: product.category,
                currentValue: product.price
            )
        }

        return TrackingProfile(tags: tags, metrics: metrics)
    }

    func fetchMetricTemplates() async throws -> [MetricTemplate] {
        []
    }

    func saveTrackingProfile(userId: UserID, profile: TrackingProfile) async throws {
    }

    func updateMetricTag(userId: UserID, metricId: MetricID, tagId: TagID) async throws {
    }
}
