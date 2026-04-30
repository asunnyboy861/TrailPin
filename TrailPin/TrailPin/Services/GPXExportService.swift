import Foundation

final class GPXExportService {

    static func export(track: Track, points: [TrackPoint], waypoints: [Waypoint]) -> String {
        var gpx = """
        <?xml version="1.0" encoding="UTF-8"?>
        <gpx version="1.1" creator="TrailPin"
          xmlns="http://www.topografix.com/GPX/1/1">
          <trk>
            <name>\(track.name)</name>
            <time>\(track.startDate.ISO8601Format())</time>
        """

        gpx += "\n            <trkseg>"
        for point in points {
            gpx += """

                        <trkpt lat="\(point.latitude)" lon="\(point.longitude)">
                          <ele>\(point.altitude)</ele>
                          <time>\(point.timestamp.ISO8601Format())</time>
                          <speed>\(point.speed)</speed>
                        </trkpt>
            """
        }
        gpx += "\n            </trkseg>"
        gpx += "\n          </trk>"

        for wp in waypoints {
            gpx += """

                      <wpt lat="\(wp.latitude)" lon="\(wp.longitude)">
                        <ele>\(wp.altitude)</ele>
                        <name>\(wp.name)</name>
                        <time>\(wp.timestamp.ISO8601Format())</time>
                      </wpt>
            """
        }

        gpx += "\n</gpx>"
        return gpx
    }

    static func saveToFile(gpxContent: String, filename: String) -> URL? {
        let dir = FileManager.default.temporaryDirectory
        let fileURL = dir.appendingPathComponent("\(filename).gpx")

        do {
            try gpxContent.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            return nil
        }
    }

    static func exportCSV(track: Track, points: [TrackPoint]) -> String {
        var csv = "latitude,longitude,altitude,speed,accuracy,timestamp\n"
        for point in points {
            csv += "\(point.latitude),\(point.longitude),\(point.altitude),\(point.speed),\(point.accuracy),\(point.timestamp.ISO8601Format())\n"
        }
        return csv
    }

    static func saveCSVToFile(csvContent: String, filename: String) -> URL? {
        let dir = FileManager.default.temporaryDirectory
        let fileURL = dir.appendingPathComponent("\(filename).csv")

        do {
            try csvContent.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            return nil
        }
    }
}
