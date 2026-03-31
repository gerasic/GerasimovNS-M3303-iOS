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
    
    private var trackingProfile: TrackingProfile = .empty
    private var collapsedTagIDs = Set<TagID>()

    init(userId: UserID, service: EntriesListService) {
        self.userId = userId
        self.service = service
    }

    func didLoad() {
        state = .loading

        Task {
            do {
                let profile = try await service.loadTrackingProfile(userId: userId)
                trackingProfile = profile
                let sections = makeSectionViewModels(from: profile)
                state = sections.isEmpty ? .empty : .content(sections: sections)
            } catch {
                state = .error(message: makeErrorMessage(from: error))
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
        if collapsedTagIDs.contains(tagId) {
            collapsedTagIDs.remove(tagId)
        } else {
            collapsedTagIDs.insert(tagId)
        }

        let sections = makeSectionViewModels(from: trackingProfile)
        state = sections.isEmpty ? .empty : .content(sections: sections)
    }

    private func renderCurrentState() {
        view?.render(state)
    }

    private func makeSectionViewModels(from profile: TrackingProfile) -> [EntriesListSectionViewModel] {
        profile.tags.map { tag in
            let isCollapsed = collapsedTagIDs.contains(tag.id)
            let metrics = profile.metrics.filter { $0.tagId == tag.id }

            let items: [EntriesListMetricCellViewModel] = metrics.map { metric in
                let isFilledToday = metric.currentValue != nil

                return EntriesListMetricCellViewModel(
                    id: metric.id,
                    title: metric.title,
                    todayValueText: formatValue(metric.currentValue) ?? "Не заполнено",
                    unitText: metric.unit,
                    isFilledToday: isFilledToday
                )
            }

            return EntriesListSectionViewModel(
                id: tag.id,
                title: tag.title,
                isCollapsed: isCollapsed,
                items: isCollapsed ? [EntriesListMetricCellViewModel]() : items
            )
        }
    }

    private func formatValue(_ value: Double?) -> String? {
        guard let value else {
            return nil
        }

        if value.rounded() == value {
            return String(Int(value))
        }

        return String(format: "%.2f", value)
    }

    private func makeErrorMessage(from error: Error) -> String {
        guard let networkError = error as? NetworkError else {
            return "Failed to load metrics"
        }

        switch networkError {
        case .transport:
            return "Please check your internet connection"
        case .httpStatus:
            return "The service is temporarily unavailable"
        case .invalidResponse, .decoding:
            return "Failed to process server data"
        }
    }
}
