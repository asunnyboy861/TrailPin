import SwiftUI

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    featuresSection
                    purchaseSection
                }
                .padding()
            }
            .navigationTitle("TrailPin Pro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "mountain.2.fill")
                .font(.system(size: 48))
                .foregroundStyle(Color("ForestGreen"))

            Text("Unlock the Full TrailPin Experience")
                .font(.title2.bold())
                .multilineTextAlignment(.center)

            Text("One-time purchase. No subscriptions. Ever.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 20)
    }

    private var featuresSection: some View {
        VStack(spacing: 12) {
            ProFeatureRow(icon: "mappin.and.ellipse", title: "Unlimited Waypoints", description: "No 5-waypoint limit")
            ProFeatureRow(icon: "list.bullet", title: "Unlimited Track History", description: "No 10-track limit")
            ProFeatureRow(icon: "square.and.arrow.down", title: "GPX Import", description: "Import routes from other apps")
            ProFeatureRow(icon: "tablecells", title: "CSV Export", description: "Export data for analysis")
            ProFeatureRow(icon: "paintpalette", title: "Route Colors", description: "Customize route colors")
            ProFeatureRow(icon: "chart.line.uptrend.xyaxis", title: "Elevation Profile", description: "Detailed altitude charts")
        }
    }

    private var purchaseSection: some View {
        PurchaseSectionContent()
            .padding(.top, 8)
    }
}

struct PurchaseSectionContent: View {
    @State private var purchaseManager = PurchaseManager.shared
    @State private var showErrorAlert = false
    @State private var showSuccessAlert = false

    var body: some View {
        VStack(spacing: 12) {
            if purchaseManager.isPro {
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(Color("ForestGreen"))
                    Text("Pro Unlocked!")
                        .font(.headline)
                        .foregroundStyle(Color("ForestGreen"))
                }
            } else {
                Button {
                    Task {
                        await purchaseManager.purchase()
                    }
                } label: {
                    if purchaseManager.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Buy TrailPin Pro — $3.99")
                            .bold()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("ForestGreen"))
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .disabled(purchaseManager.isLoading)

                Button("Restore Purchases") {
                    purchaseManager.restorePurchases()
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .disabled(purchaseManager.isLoading)
            }
        }
        .onChange(of: purchaseManager.showError) { _, newValue in
            showErrorAlert = newValue
        }
        .onChange(of: purchaseManager.purchaseSuccess) { _, newValue in
            showSuccessAlert = newValue
        }
        .alert("Error", isPresented: $showErrorAlert) {
            Button("OK") {
                purchaseManager.showError = false
            }
        } message: {
            Text(purchaseManager.errorMessage ?? "An unknown error occurred.")
        }
        .alert("Success", isPresented: $showSuccessAlert) {
            Button("OK") {
                purchaseManager.purchaseSuccess = false
            }
        } message: {
            Text("Thank you for purchasing TrailPin Pro!")
        }
    }
}

struct ProFeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(Color("ForestGreen"))
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.bold())
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "checkmark")
                .foregroundStyle(Color("ForestGreen"))
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
