protocol TrackingSettingsRouter: AnyObject {
    func closeWithSavedProfile(_ profile: TrackingProfile)
    func close()
}
