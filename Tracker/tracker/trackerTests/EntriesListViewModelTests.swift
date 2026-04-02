import Foundation
import Testing
@testable import tracker

@MainActor
struct EntriesListViewModelTests {

    @Test
    func didLoadBuildsContentState() async throws {
        let service = MockEntriesListService()
        service.profile = makeProfile()
        let viewModel = EntriesListViewModel(userId: "user-1", service: service)

        viewModel.didLoad()
        await waitForTasks()

        guard case let .content(sections) = viewModel.state else {
            Issue.record("Expected content state after successful load")
            return
        }

        #expect(sections.count == 2)
        #expect(sections[0].title == "Health")
        #expect(sections[0].items.count == 2)
        #expect(sections[0].items[0].title == "Sleep")
        #expect(sections[0].items[0].todayValueText == "8")
        #expect(sections[0].items[0].unitText == "h")
        #expect(sections[0].items[0].isFilledToday == true)
    }

    @Test
    func didLoadBuildsEmptyStateForEmptyProfile() async throws {
        let service = MockEntriesListService()
        service.profile = .empty
        let viewModel = EntriesListViewModel(userId: "user-1", service: service)

        viewModel.didLoad()
        await waitForTasks()

        #expect(viewModel.state == .empty)
    }

    @Test
    func didLoadBuildsErrorStateForTransportError() async throws {
        let service = MockEntriesListService()
        service.error = NetworkError.transport
        let viewModel = EntriesListViewModel(userId: "user-1", service: service)

        viewModel.didLoad()
        await waitForTasks()

        guard case let .error(errorViewModel) = viewModel.state else {
            Issue.record("Expected error state for transport failure")
            return
        }

        #expect(errorViewModel.title == "Connection Error")
        #expect(errorViewModel.message == "Please check your internet connection")
        #expect(errorViewModel.actionTitle == "Retry")
    }

    @Test
    func didToggleSectionUpdatesCollapsedState() async throws {
        let service = MockEntriesListService()
        service.profile = makeProfile()
        let viewModel = EntriesListViewModel(userId: "user-1", service: service)

        viewModel.didLoad()
        await waitForTasks()
        viewModel.didToggleSection(tagId: "health")

        guard case let .content(collapsedSections) = viewModel.state else {
            Issue.record("Expected content state after collapsing section")
            return
        }

        #expect(collapsedSections[0].isCollapsed == true)
        #expect(collapsedSections[0].items.isEmpty)

        viewModel.didToggleSection(tagId: "health")

        guard case let .content(expandedSections) = viewModel.state else {
            Issue.record("Expected content state after expanding section")
            return
        }

        #expect(expandedSections[0].isCollapsed == false)
        #expect(expandedSections[0].items.count == 2)
    }

    @Test
    func metricWithoutValueUsesFallbackText() async throws {
        let service = MockEntriesListService()
        service.profile = makeProfile()
        let viewModel = EntriesListViewModel(userId: "user-1", service: service)

        viewModel.didLoad()
        await waitForTasks()

        guard case let .content(sections) = viewModel.state else {
            Issue.record("Expected content state after successful load")
            return
        }

        let waterMetric = sections[1].items[0]
        #expect(waterMetric.title == "Water")
        #expect(waterMetric.todayValueText == "Не заполнено")
        #expect(waterMetric.isFilledToday == false)
    }

    private func makeProfile() -> TrackingProfile {
        TrackingProfile(
            tags: [
                MetricTag(id: "health", title: "Health", isSystem: false),
                MetricTag(id: "body", title: "Body", isSystem: false)
            ],
            metrics: [
                TrackedMetric(id: "sleep", title: "Sleep", unit: "h", tagId: "health", currentValue: 8),
                TrackedMetric(id: "steps", title: "Steps", unit: "count", tagId: "health", currentValue: 12000),
                TrackedMetric(id: "water", title: "Water", unit: "l", tagId: "body", currentValue: nil)
            ]
        )
    }

    private func waitForTasks() async {
        for _ in 0..<10 {
            await Task.yield()
        }
    }
}
