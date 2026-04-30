import Foundation
import SwiftData
import Observation

@Observable
final class TrackDetailVM {

    var showExportSheet = false
    var showCSVExportSheet = false
    var isEditingName = false
    var editedName = ""

    var gpxFileURL: URL?
    var csvFileURL: URL?

    func exportGPX(track: Track, points: [TrackPoint], waypoints: [Waypoint]) {
        let content = GPXExportService.export(track: track, points: points, waypoints: waypoints)
        let filename = track.name.replacingOccurrences(of: " ", with: "_")
        gpxFileURL = GPXExportService.saveToFile(gpxContent: content, filename: filename)
        showExportSheet = true
    }

    func exportCSV(track: Track, points: [TrackPoint]) {
        let content = GPXExportService.exportCSV(track: track, points: points)
        let filename = track.name.replacingOccurrences(of: " ", with: "_")
        csvFileURL = GPXExportService.saveCSVToFile(csvContent: content, filename: filename)
        showCSVExportSheet = true
    }

    func updateTrackName(_ track: Track, modelContext: ModelContext) {
        track.name = editedName
        try? modelContext.save()
        isEditingName = false
    }

    func deleteTrack(_ track: Track, modelContext: ModelContext) {
        modelContext.delete(track)
        try? modelContext.save()
    }
}
