import SwiftUI

struct SettingsView: View {
    @State private var vm = SettingsVM()
    @State private var showPaywall = false

    var body: some View {
        NavigationStack {
            Form {
                unitsSection
                powerSection
                mapSection
                privacySection
                proSection
                aboutSection
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
            .onReceive(NotificationCenter.default.publisher(for: .showPaywall)) { _ in
                showPaywall = true
            }
        }
    }

    private var unitsSection: some View {
        Section("Units") {
            Toggle("Use Miles", isOn: $vm.appSettings.useMiles)
        }
    }

    private var powerSection: some View {
        Section("Battery Optimization") {
            Picker("Power Mode", selection: $vm.appSettings.powerMode) {
                ForEach(AppSettings.PowerMode.allCases, id: \.self) { mode in
                    HStack {
                        Image(systemName: mode.icon)
                        Text(mode.rawValue)
                    }
                }
            }

            Toggle("Auto Optimize", isOn: $vm.appSettings.autoBatteryOptimize)

            HStack {
                Text("Estimated Battery Life")
                Spacer()
                Text(vm.appSettings.powerMode.estimatedBatteryHours)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var mapSection: some View {
        Section("Map") {
            Picker("Map Style", selection: $vm.appSettings.mapStyle) {
                ForEach(AppSettings.MapStyleOption.allCases, id: \.self) { style in
                    HStack {
                        Image(systemName: style.icon)
                        Text(style.rawValue)
                    }
                }
            }
        }
    }

    private var privacySection: some View {
        Section("Privacy") {
            HStack {
                Image(systemName: "lock.shield.fill")
                    .foregroundStyle(Color("ForestGreen"))
                Text("Your data stays on your device")
                    .font(.subheadline)
            }

            Link("Privacy Policy", destination: URL(string: "https://asunnyboy861.github.io/TrailPin/privacy.html")!)
            Link("Support", destination: URL(string: "https://asunnyboy861.github.io/TrailPin/support.html")!)
        }
    }

    private var proSection: some View {
        Section("TrailPin Pro") {
            if PurchaseManager.shared.isPro {
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(Color("ForestGreen"))
                    Text("Pro Unlocked")
                        .foregroundStyle(Color("ForestGreen"))
                }
            } else {
                Button {
                    showPaywall = true
                } label: {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundStyle(Color("WarmOrange"))
                        Text("Upgrade to Pro")
                    }
                }

                Button {
                    PurchaseManager.shared.restorePurchases()
                } label: {
                    Text("Restore Purchases")
                        .font(.subheadline)
                }
            }
        }
    }

    private var aboutSection: some View {
        Section("About") {
            NavigationLink {
                ContactSupportView()
            } label: {
                Label("Contact Support", systemImage: "envelope")
            }

            HStack {
                Text("Version")
                Spacer()
                Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                    .foregroundStyle(.secondary)
            }
        }
    }
}
