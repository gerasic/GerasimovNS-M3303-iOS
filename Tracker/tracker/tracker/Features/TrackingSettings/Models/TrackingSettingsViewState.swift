enum TrackingSettingsViewState: Equatable {
    case initial
    case loading
    case content(profile: TrackingProfile, templates: [MetricTemplate], tags: [MetricTag])
    case saving
    case error(message: String)
}
