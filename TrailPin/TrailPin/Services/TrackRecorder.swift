import SwiftData
import CoreLocation
import Observation

@Observable
final class TrackRecorder {

    private var startTime: Date?
    var totalDistance: Double = 0
    private var lastLocation: CLLocation?
    private var pauseStartTime: Date?
    private var totalPauseDuration: TimeInterval = 0

    var isRecording = false
    var isPaused = false
    var currentTrack: Track?
    var currentPoints: [TrackPoint] = []
    var currentWaypoints: [Waypoint] = []

    var elapsedTime: TimeInterval {
        guard let start = startTime else { return 0 }
        var elapsed = Date().timeIntervalSince(start) - totalPauseDuration
        if isPaused, let pauseStart = pauseStartTime {
            elapsed -= Date().timeIntervalSince(pauseStart)
        }
        return max(0, elapsed)
    }

    var currentSpeed: Double {
        guard let last = lastLocation, last.speed >= 0 else { return 0 }
        return last.speed
    }

    var currentAltitude: Double {
        lastLocation?.altitude ?? 0
    }

    var elevationGain: Double {
        var gain: Double = 0
        var prevAlt: Double?
        for point in currentPoints {
            if let prev = prevAlt, point.altitude > prev {
                gain += point.altitude - prev
            }
            prevAlt = point.altitude
        }
        return gain
    }

    var elevationLoss: Double {
        var loss: Double = 0
        var prevAlt: Double?
        for point in currentPoints {
            if let prev = prevAlt, point.altitude < prev {
                loss += prev - point.altitude
            }
            prevAlt = point.altitude
        }
        return loss
    }

    func startNewTrack(modelContext: ModelContext, name: String? = nil) {
        currentPoints = []
        currentWaypoints = []
        totalDistance = 0
        lastLocation = nil
        startTime = Date()
        totalPauseDuration = 0
        pauseStartTime = nil
        isRecording = true
        isPaused = false

        let track = Track(
            name: name ?? "Track \(formatDate(Date()))",
            startDate: Date()
        )
        modelContext.insert(track)
        currentTrack = track
    }

    func addPoint(_ location: CLLocation, modelContext: ModelContext) {
        guard isRecording, !isPaused else { return }

        if let last = lastLocation {
            let distance = location.distance(from: last)
            if distance < 3 { return }
            totalDistance += distance
        }

        let point = TrackPoint(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            altitude: location.altitude,
            speed: location.speed,
            accuracy: location.horizontalAccuracy,
            timestamp: Date()
        )
        currentPoints.append(point)
        lastLocation = location

        if let track = currentTrack {
            track.distance = totalDistance
            track.duration = elapsedTime
            track.pointCount = currentPoints.count
        }
    }

    func addWaypoint(name: String, location: CLLocation, modelContext: ModelContext) {
        guard let track = currentTrack else { return }
        let waypoint = Waypoint(
            name: name,
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            altitude: location.altitude,
            timestamp: Date()
        )
        waypoint.track = track
        modelContext.insert(waypoint)
        currentWaypoints.append(waypoint)
    }

    func pause() {
        isPaused = true
        pauseStartTime = Date()
    }

    func resume() {
        if let pauseStart = pauseStartTime {
            totalPauseDuration += Date().timeIntervalSince(pauseStart)
        }
        pauseStartTime = nil
        isPaused = false
    }

    func stopAndSave(modelContext: ModelContext) {
        guard let track = currentTrack else { return }
        track.endDate = Date()
        track.distance = totalDistance
        track.duration = elapsedTime
        track.pointCount = currentPoints.count

        for point in currentPoints {
            point.track = track
            modelContext.insert(point)
        }

        isRecording = false
        isPaused = false
        currentTrack = nil

        try? modelContext.save()
    }

    func discardTrack(modelContext: ModelContext) {
        if let track = currentTrack {
            modelContext.delete(track)
        }
        isRecording = false
        isPaused = false
        currentTrack = nil
        currentPoints = []
        currentWaypoints = []
    }

    private func formatDate(_ date: Date) -> String {
        date.formatted(.dateTime.month().day().hour().minute())
    }
}
