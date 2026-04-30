import SwiftUI
import SwiftData
import CoreLocation
import Observation

@Observable
final class TrackingVM {

    var locationManager = LocationManager()
    var trackRecorder = TrackRecorder()
    var batteryOptimizer = BatteryOptimizer()
    var appSettings = AppSettings()

    var showPermissionAlert = false
    var showWaypointSheet = false
    var waypointName = ""
    var showStopConfirmation = false

    var formattedElapsedTime: String {
        let time = trackRecorder.elapsedTime
        let hours = Int(time) / 3600
        let minutes = Int(time) % 3600 / 60
        let seconds = Int(time) % 60
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        }
        return String(format: "%d:%02d", minutes, seconds)
    }

    var formattedDistance: String {
        appSettings.formatDistance(trackRecorder.totalDistance)
    }

    var formattedSpeed: String {
        appSettings.formatSpeed(trackRecorder.currentSpeed)
    }

    var formattedAltitude: String {
        appSettings.formatAltitude(trackRecorder.currentAltitude)
    }

    var formattedElevationGain: String {
        appSettings.formatAltitude(trackRecorder.elevationGain)
    }

    var formattedElevationLoss: String {
        appSettings.formatAltitude(trackRecorder.elevationLoss)
    }

    var canAddWaypoint: Bool {
        guard trackRecorder.isRecording else { return false }
        let isPro = PurchaseManager.shared.isPro
        if isPro { return true }
        return trackRecorder.currentWaypoints.count < 5
    }

    func requestPermission() {
        locationManager.requestPermission()
    }

    func startRecording(modelContext: ModelContext) {
        guard locationManager.isAuthorized else {
            showPermissionAlert = true
            return
        }

        let distanceFilter = appSettings.powerMode.distanceFilter
        let accuracy: CLLocationAccuracy = {
            switch appSettings.powerMode {
            case .performance: return kCLLocationAccuracyBest
            case .balanced: return kCLLocationAccuracyHundredMeters
            case .ultraSaving: return kCLLocationAccuracyThreeKilometers
            }
        }()

        locationManager.startTracking(distanceFilter: distanceFilter, accuracy: accuracy)
        trackRecorder.startNewTrack(modelContext: modelContext)
        batteryOptimizer.updateBatteryLevel()
    }

    func pauseRecording() {
        trackRecorder.pause()
    }

    func resumeRecording() {
        trackRecorder.resume()
    }

    func stopRecording(modelContext: ModelContext) {
        trackRecorder.stopAndSave(modelContext: modelContext)
        locationManager.stopTracking()
    }

    func discardRecording(modelContext: ModelContext) {
        trackRecorder.discardTrack(modelContext: modelContext)
        locationManager.stopTracking()
    }

    func addWaypoint(modelContext: ModelContext) {
        guard let location = locationManager.currentLocation else { return }
        trackRecorder.addWaypoint(name: waypointName, location: location, modelContext: modelContext)
        waypointName = ""
        showWaypointSheet = false
    }

    func handleLocationUpdate(modelContext: ModelContext) {
        guard let location = locationManager.currentLocation else { return }
        trackRecorder.addPoint(location, modelContext: modelContext)
    }

    func switchPowerMode(_ mode: AppSettings.PowerMode) {
        appSettings.powerMode = mode
        batteryOptimizer.currentMode = mode

        if locationManager.isTracking {
            let distanceFilter = mode.distanceFilter
            let accuracy: CLLocationAccuracy = {
                switch mode {
                case .performance: return kCLLocationAccuracyBest
                case .balanced: return kCLLocationAccuracyHundredMeters
                case .ultraSaving: return kCLLocationAccuracyThreeKilometers
                }
            }()
            locationManager.stopTracking()
            locationManager.startTracking(distanceFilter: distanceFilter, accuracy: accuracy)
        }
    }
}
