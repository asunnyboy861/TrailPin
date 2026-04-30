import Observation

@Observable
final class SettingsVM {
    var appSettings = AppSettings()
    var showPaywall = false
    var showContactSupport = false
}
