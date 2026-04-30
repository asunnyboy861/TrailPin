import CoreLocation
import Observation

@Observable
final class LocationManager: NSObject, CLLocationManagerDelegate {

    private let manager = CLLocationManager()

    var currentLocation: CLLocation?
    var isTracking = false
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var gpsSignalStrength: GPSSignalStrength = .searching

    enum GPSSignalStrength {
        case searching
        case weak
        case strong

        var color: String {
            switch self {
            case .searching: return "gray"
            case .weak: return "yellow"
            case .strong: return "green"
            }
        }

        var icon: String {
            switch self {
            case .searching: return "location.circle"
            case .weak: return "location.circle.fill"
            case .strong: return "location.circle.fill"
            }
        }
    }

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.distanceFilter = 10
        manager.pausesLocationUpdatesAutomatically = false
        manager.allowsBackgroundLocationUpdates = true
        manager.showsBackgroundLocationIndicator = true
    }

    func requestPermission() {
        manager.requestAlwaysAuthorization()
    }

    func startTracking(distanceFilter: Double = 10, accuracy: CLLocationAccuracy = kCLLocationAccuracyHundredMeters) {
        manager.desiredAccuracy = accuracy
        manager.distanceFilter = distanceFilter
        manager.startUpdatingLocation()
        isTracking = true
    }

    func stopTracking() {
        manager.stopUpdatingLocation()
        isTracking = false
        gpsSignalStrength = .searching
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        guard location.horizontalAccuracy < 100 else {
            gpsSignalStrength = .weak
            return
        }
        currentLocation = location
        gpsSignalStrength = .strong
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
    }

    var isAuthorized: Bool {
        authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
    }
}
