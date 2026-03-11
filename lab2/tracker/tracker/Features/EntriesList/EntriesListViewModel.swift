import Foundation

@MainActor
final class EntriesListViewModel: EntriesListViewModelInput {
    weak var view: EntriesListView?

    private let userId: UserID
    private let service: EntriesListService
    private let router: EntriesListRouter

    init(userId: UserID, service: EntriesListService, router: EntriesListRouter) {
        self.userId = userId
        self.service = service
        self.router = router
    }

    func didLoad() {
        view?.render(.loading)

        Task {
            do {
                let sections = try await service.loadSections(userId: userId)
                view?.render(sections.isEmpty ? .empty : .content(sections: sections))
            } catch {
                view?.render(.error(message: "Не удалось загрузить метрики"))
            }
        }
    }

    func didTapEditMetrics() {
        router.openTrackingSettings(userId: userId)
    }

    func didTapMetric(metricId: MetricID) {
        router.openMetricDetails(userId: userId, metricId: metricId)
    }

    func didTapAddValue(metricId: MetricID, value: Double, recordedAt: Date) {
        Task {
            try? await service.saveMetricValue(
                userId: userId,
                metricId: metricId,
                value: value,
                recordedAt: recordedAt
            )
            didLoad()
        }
    }

    func didToggleSection(tagId: TagID) {
        didLoad()
    }
}
