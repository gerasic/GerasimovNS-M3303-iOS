import Foundation

@MainActor
final class MetricDetailsViewModel: MetricDetailsViewModelInput {
    weak var view: MetricDetailsView? {
        didSet {
            renderCurrentState()
        }
    }
    var onOpenEntry: ((EntryID) -> Void)?
    var onClose: (() -> Void)?
    var onMetricUpdated: (() -> Void)?
    private(set) var state: MetricDetailsViewState = .initial {
        didSet {
            renderCurrentState()
        }
    }

    private let userId: UserID
    private let metricId: MetricID
    private let service: MetricDetailsService
    private var range: ChartRange = .month

    init(userId: UserID, metricId: MetricID, service: MetricDetailsService) {
        self.userId = userId
        self.metricId = metricId
        self.service = service
    }

    func didLoad() {
        load(range: range)
    }

    func didTapSaveValue(_ value: Double, recordedAt: Date) {
        state = .saving

        Task {
            do {
                try await service.saveMetricValue(
                    userId: userId,
                    metricId: metricId,
                    value: value,
                    recordedAt: recordedAt
                )
                onMetricUpdated?()
                load(range: range)
            } catch {
                state = .error(message: "Не удалось сохранить значение")
            }
        }
    }

    func didChangeMetricTag(tagId: TagID) {
        state = .saving

        Task {
            do {
                try await service.updateMetricTag(userId: userId, metricId: metricId, tagId: tagId)
                onMetricUpdated?()
                load(range: range)
            } catch {
                state = .error(message: "Не удалось изменить тег")
            }
        }
    }

    func didChangeRange(_ range: ChartRange) {
        self.range = range
        load(range: range)
    }

    func didTapPoint(entryId: EntryID) {
        onOpenEntry?(entryId)
    }

    func didTapBack() {
        onClose?()
    }

    private func load(range: ChartRange) {
        state = .loading

        Task {
            do {
                let details = try await service.loadMetricDetails(userId: userId, metricId: metricId, range: range)
                if details.points.isEmpty {
                    state = .empty
                } else {
                    state = .content(
                        metric: details.metric,
                        lastValue: details.lastValue,
                        points: details.points,
                        range: range,
                        tags: details.tags
                    )
                }
            } catch {
                state = .error(message: "Не удалось загрузить данные метрики")
            }
        }
    }

    private func renderCurrentState() {
        view?.render(state)
    }
}
