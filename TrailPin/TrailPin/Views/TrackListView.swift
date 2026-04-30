import SwiftUI
import SwiftData

struct TrackListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Track.startDate, order: .reverse) private var tracks: [Track]
    @State private var vm = TrackListVM()
    @State private var selectedTrack: Track?
    @State private var showProAlert = false

    private var visibleTracks: [Track] {
        let isPro = PurchaseManager.shared.isPro
        if isPro { return tracks }
        return Array(tracks.prefix(10))
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(visibleTracks) { track in
                    NavigationLink(destination: TrackDetailView(track: track)) {
                        TrackRow(track: track)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            vm.deleteTrack(track, modelContext: modelContext)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }

                if !PurchaseManager.shared.isPro && tracks.count > 10 {
                    Section {
                        Button {
                            showProAlert = true
                        } label: {
                            HStack {
                                Image(systemName: "lock.fill")
                                Text("Unlock Unlimited Tracks")
                                    .foregroundStyle(Color("ForestGreen"))
                            }
                        }
                    }
                }
            }
            .navigationTitle("My Tracks")
            .searchable(text: $vm.searchText, prompt: "Search tracks")
            .toolbar {
                if PurchaseManager.shared.isPro {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            vm.showImportPicker = true
                        } label: {
                            Image(systemName: "square.and.arrow.down")
                        }
                    }
                }
            }
            .fileImporter(isPresented: $vm.showImportPicker, allowedContentTypes: [.gpx]) { result in
                switch result {
                case .success(let url):
                    vm.importGPX(from: url, modelContext: modelContext)
                case .failure:
                    break
                }
            }
            .alert("Upgrade to Pro", isPresented: $showProAlert) {
                Button("Learn More") {
                    NotificationCenter.default.post(name: .showPaywall, object: nil)
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Unlock unlimited tracks, GPX import, and more with TrailPin Pro.")
            }
            .overlay {
                if tracks.isEmpty {
                    ContentUnavailableView(
                        "No Tracks Yet",
                        systemImage: "map",
                        description: Text("Start recording your first route!")
                    )
                }
            }
        }
    }
}

struct TrackRow: View {
    let track: Track
    private let settings = AppSettings()

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: track.activityIcon)
                .font(.title2)
                .foregroundStyle(Color("ForestGreen"))
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 2) {
                Text(track.name)
                    .font(.headline)
                HStack(spacing: 8) {
                    Text(track.startDate.formatted(.dateTime.month().day()))
                    Text(settings.formatDistance(track.distance))
                    Text(track.formattedDuration)
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
