import SwiftUI
import SwiftData

struct WaypointSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var vm: TrackingVM

    var body: some View {
        NavigationStack {
            Form {
                Section("Waypoint Name") {
                    TextField("e.g. Trail Junction", text: $vm.waypointName)
                }

                Section {
                    HStack {
                        Label("Waypoints", systemImage: "mappin.and.ellipse")
                        Spacer()
                        Text("\(vm.trackRecorder.currentWaypoints.count)")
                            .foregroundStyle(.secondary)
                    }

                    if !PurchaseManager.shared.isPro {
                        Text("Free: max 5 waypoints per track")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Add Waypoint")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        vm.addWaypoint(modelContext: modelContext)
                    }
                    .disabled(vm.waypointName.isEmpty)
                }
            }
        }
    }
}
