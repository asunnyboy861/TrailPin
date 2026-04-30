import Foundation
import SwiftData
import Observation
import CoreLocation

@Observable
final class TrackListVM {

    var searchText = ""
    var showImportPicker = false

    var filteredTracks: [Track] {
        guard !searchText.isEmpty else { return [] }
        return []
    }

    func deleteTrack(_ track: Track, modelContext: ModelContext) {
        modelContext.delete(track)
        try? modelContext.save()
    }

    func importGPX(from url: URL, modelContext: ModelContext) {
        guard let result = GPXImportService.importGPX(from: url) else { return }

        let track = Track(name: result.name, startDate: Date())
        modelContext.insert(track)

        var totalDistance: Double = 0
        var prevPoint: TrackPoint?
        for point in result.points {
            if let prev = prevPoint {
                let loc1 = CLLocation(latitude: prev.latitude, longitude: prev.longitude)
                let loc2 = CLLocation(latitude: point.latitude, longitude: point.longitude)
                totalDistance += loc1.distance(from: loc2)
            }
            point.track = track
            modelContext.insert(point)
            prevPoint = point
        }

        for waypoint in result.waypoints {
            waypoint.track = track
            modelContext.insert(waypoint)
        }

        track.distance = totalDistance
        track.pointCount = result.points.count
        if let first = result.points.first?.timestamp {
            track.startDate = first
        }
        if let last = result.points.last?.timestamp {
            track.endDate = last
            track.duration = last.timeIntervalSince(track.startDate)
        }

        try? modelContext.save()
    }
}
