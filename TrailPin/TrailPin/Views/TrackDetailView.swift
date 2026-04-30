import SwiftUI
import SwiftData
import MapKit

struct TrackDetailView: View {
    @Environment(\.modelContext) private var modelContext
    let track: Track
    @State private var vm = TrackDetailVM()
    @State private var position: MapCameraPosition = .automatic

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                mapPreview
                    .frame(height: 240)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)

                trackStats
                    .padding(.horizontal)

                waypointsList
                    .padding(.horizontal)

                actionButtons
                    .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle(track.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        vm.editedName = track.name
                        vm.isEditingName = true
                    } label: {
                        Label("Rename", systemImage: "pencil")
                    }

                    Button(role: .destructive) {
                        vm.deleteTrack(track, modelContext: modelContext)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .alert("Rename Track", isPresented: $vm.isEditingName) {
            TextField("Track name", text: $vm.editedName)
            Button("Save") { vm.updateTrackName(track, modelContext: modelContext) }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $vm.showExportSheet) {
            if let url = vm.gpxFileURL {
                ShareSheet(items: [url])
            }
        }
        .sheet(isPresented: $vm.showCSVExportSheet) {
            if let url = vm.csvFileURL {
                ShareSheet(items: [url])
            }
        }
    }

    private var mapPreview: some View {
        Map(position: $position) {
            let coordinates = track.points.map {
                CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
            }
            if !coordinates.isEmpty {
                MapPolyline(coordinates: coordinates)
                    .stroke(Color("VibrantGreen"), lineWidth: 3)

                ForEach(track.waypoints) { wp in
                    Annotation(wp.name, coordinate: CLLocationCoordinate2D(latitude: wp.latitude, longitude: wp.longitude)) {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundStyle(Color("WarmOrange"))
                    }
                }
            }
        }
        .mapStyle(.standard)
    }

    private var trackStats: some View {
        let settings = AppSettings()
        return LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            StatCard(title: "Distance", value: settings.formatDistance(track.distance), icon: "point.topleft.down.to.point.bottomright.curvepath")
            StatCard(title: "Duration", value: track.formattedDuration, icon: "clock")
            StatCard(title: "Pace", value: track.formattedPace, icon: "speedometer")
            StatCard(title: "Points", value: "\(track.pointCount)", icon: "point.3.connected.trianglepath.dotted")
        }
    }

    private var waypointsList: some View {
        Group {
            if !track.waypoints.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Waypoints")
                        .font(.headline)

                    ForEach(track.waypoints) { wp in
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundStyle(Color("WarmOrange"))
                            Text(wp.name)
                                .font(.subheadline)
                            Spacer()
                            Text(AppSettings().formatAltitude(wp.altitude))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button {
                vm.exportGPX(track: track, points: track.points, waypoints: track.waypoints)
            } label: {
                Label("Export GPX", systemImage: "square.and.arrow.up")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color("ForestGreen"))

            if PurchaseManager.shared.isPro {
                Button {
                    vm.exportCSV(track: track, points: track.points)
                } label: {
                    Label("Export CSV", systemImage: "tablecells")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(Color("ForestGreen"))
            Text(value)
                .font(.title3.bold())
                .contentTransition(.numericText())
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
