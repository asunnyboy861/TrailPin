import SwiftUI
import SwiftData
import MapKit

struct TrackingView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var vm = TrackingVM()
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)

    var body: some View {
        ZStack {
            mapLayer

            if vm.trackRecorder.isRecording || vm.trackRecorder.isPaused {
                VStack {
                    Spacer()
                    activeControls
                }
            } else {
                VStack {
                    Spacer()
                    startButton
                }
            }

            VStack {
                statsOverlay
                Spacer()
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        .alert("Location Permission Required", isPresented: $vm.showPermissionAlert) {
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("TrailPin needs location access to record your routes.")
        }
        .sheet(isPresented: $vm.showWaypointSheet) {
            WaypointSheet(vm: vm)
        }
        .confirmationDialog("Stop Recording?", isPresented: $vm.showStopConfirmation) {
            Button("Save Track") {
                vm.stopRecording(modelContext: modelContext)
            }
            Button("Discard", role: .destructive) {
                vm.discardRecording(modelContext: modelContext)
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Do you want to save this track?")
        }
        .onAppear {
            vm.requestPermission()
            vm.batteryOptimizer.updateBatteryLevel()
        }
        .onChange(of: vm.locationManager.currentLocation) {
            vm.handleLocationUpdate(modelContext: modelContext)
        }
    }

    private var mapLayer: some View {
        Map(position: $position) {
            UserAnnotation()

            if vm.trackRecorder.isRecording || vm.trackRecorder.isPaused {
                MapPolyline(coordinates: vm.trackRecorder.currentPoints.map {
                    CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
                })
                .stroke(Color("VibrantGreen"), lineWidth: 4)

                ForEach(vm.trackRecorder.currentWaypoints, id: \.name) { wp in
                    Annotation(wp.name, coordinate: CLLocationCoordinate2D(latitude: wp.latitude, longitude: wp.longitude)) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.title2)
                            .foregroundStyle(Color("WarmOrange"))
                    }
                }
            }
        }
        .mapStyle(vm.appSettings.mapStyle.mapStyle)
    }

    private var statsOverlay: some View {
        VStack(spacing: 4) {
            HStack {
                GPSSignalView(strength: vm.locationManager.gpsSignalStrength)
                Spacer()
                BatteryIndicator(optimizer: vm.batteryOptimizer)
            }
            .padding(.horizontal, 16)
            .padding(.top, 56)

            if vm.trackRecorder.isRecording || vm.trackRecorder.isPaused {
                StatsOverlay(
                    distance: vm.formattedDistance,
                    time: vm.formattedElapsedTime,
                    speed: vm.formattedSpeed,
                    elevationGain: vm.formattedElevationGain,
                    elevationLoss: vm.formattedElevationLoss,
                    isRecording: vm.trackRecorder.isRecording,
                    isPaused: vm.trackRecorder.isPaused
                )
                .padding(.horizontal, 16)
            }
        }
    }

    private var startButton: some View {
        VStack(spacing: 12) {
            RecordButton(isRecording: false, isPaused: false) {
                vm.startRecording(modelContext: modelContext)
            }
            Text("Start Recording")
                .font(.headline)
                .foregroundStyle(Color("ForestGreen"))
        }
        .padding(.bottom, 100)
    }

    private var activeControls: some View {
        VStack(spacing: 12) {
            StatsOverlay(
                distance: vm.formattedDistance,
                time: vm.formattedElapsedTime,
                speed: vm.formattedSpeed,
                elevationGain: vm.formattedElevationGain,
                elevationLoss: vm.formattedElevationLoss,
                isRecording: vm.trackRecorder.isRecording,
                isPaused: vm.trackRecorder.isPaused
            )
            .padding(.horizontal, 16)

            HStack(spacing: 24) {
                Button {
                    if vm.trackRecorder.isPaused {
                        vm.resumeRecording()
                    } else {
                        vm.pauseRecording()
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: vm.trackRecorder.isPaused ? "play.fill" : "pause.fill")
                            .font(.title2)
                        Text(vm.trackRecorder.isPaused ? "Resume" : "Pause")
                            .font(.caption)
                    }
                    .foregroundStyle(Color("WarmOrange"))
                    .frame(width: 64, height: 64)
                    .background(Color("WarmOrange").opacity(0.15))
                    .clipShape(Circle())
                }

                Button {
                    vm.showWaypointSheet = true
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.title2)
                        Text("Pin")
                            .font(.caption)
                    }
                    .foregroundStyle(Color("VibrantGreen"))
                    .frame(width: 64, height: 64)
                    .background(Color("VibrantGreen").opacity(0.15))
                    .clipShape(Circle())
                }
                .disabled(!vm.canAddWaypoint)

                Button {
                    vm.showStopConfirmation = true
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: "stop.fill")
                            .font(.title2)
                        Text("Stop")
                            .font(.caption)
                    }
                    .foregroundStyle(.white)
                    .frame(width: 64, height: 64)
                    .background(Color.red)
                    .clipShape(Circle())
                }
            }
            .padding(.bottom, 100)
        }
    }
}
