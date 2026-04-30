import SwiftUI
import SwiftData

@main
struct TrailPinApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: [Track.self, TrackPoint.self, Waypoint.self])
    }
}
