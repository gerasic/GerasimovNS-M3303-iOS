@MainActor
final class TrackingSettingsViewModel: TrackingSettingsViewModelInput {
    weak var view: TrackingSettingsView?
    var onClose: (() -> Void)?
    var onSavedProfile: ((TrackingProfile) -> Void)?

    private let userId: UserID
    private let service: TrackingSettingsService
    private var profile: TrackingProfile = .empty
    private var templates: [MetricTemplate] = []

    init(userId: UserID, service: TrackingSettingsService) {
        self.userId = userId
        self.service = service
    }

    func didLoad() {
        view?.render(.loading)

        Task {
            do {
                async let profileTask = service.loadProfile(userId: userId)
                async let templatesTask = service.loadMetricTemplates()
                profile = try await profileTask
                templates = try await templatesTask
                view?.render(.content(profile: profile, templates: templates, tags: profile.tags))
            } catch {
                view?.render(.error(message: "Не удалось загрузить настройки"))
            }
        }
    }

    func didTapAddExistingMetric(templateId: MetricID, tagId: TagID) {
    }

    func didTapCreateMetric(title: String, unit: String, tagId: TagID) {
    }

    func didTapCreateTag(title: String) {
    }

    func didChangeMetricTag(metricId: MetricID, tagId: TagID) {
    }

    func didTapSave() {
        view?.render(.saving)

        Task {
            do {
                try await service.saveProfile(userId: userId, profile: profile)
                onSavedProfile?(profile)
            } catch {
                view?.render(.error(message: "Не удалось сохранить профиль"))
            }
        }
    }

    func didTapBack() {
        onClose?()
    }
}
