import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            TrackingView()
                .tabItem {
                    Label("Track", systemImage: "map")
                }
                .tag(0)

            TrackListView()
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                }
                .tag(1)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(2)
        }
        .tint(Color("ForestGreen"))
    }
}
