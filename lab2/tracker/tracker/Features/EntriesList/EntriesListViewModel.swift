import Foundation

@MainActor
final class EntriesListViewModel: EntriesListViewModelInput {
    weak var view: EntriesListView?
    var onOpenTrackingSettings: ((UserID) -> Void)?
    var onOpenMetricDetails: ((UserID, MetricID) -> Void)?

    private let userId: UserID
    private let service: EntriesListService

    init(userId: UserID, service: EntriesListService) {
        self.userId = userId
        self.service = service
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
        onOpenTrackingSettings?(userId)
    }

    func didTapMetric(metricId: MetricID) {
        onOpenMetricDetails?(userId, metricId)
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
