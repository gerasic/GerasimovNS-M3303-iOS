import Foundation

@MainActor
final class EntriesListViewModel: EntriesListViewModelInput {
    weak var view: EntriesListView? {
        didSet {
            renderCurrentState()
        }
    }
    var onOpenTrackingSettings: ((UserID) -> Void)?
    var onOpenMetricDetails: ((UserID, MetricID) -> Void)?
    private(set) var state: EntriesListViewState = .initial {
        didSet {
            renderCurrentState()
        }
    }

    private let userId: UserID
    private let service: EntriesListService

    init(userId: UserID, service: EntriesListService) {
        self.userId = userId
        self.service = service
    }

    func didLoad() {
        state = .loading

        Task {
            do {
                let sections = try await service.loadSections(userId: userId)
                state = sections.isEmpty ? .empty : .content(sections: sections)
            } catch {
                state = .error(message: "Не удалось загрузить метрики")
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

    private func renderCurrentState() {
        view?.render(state)
    }
}
