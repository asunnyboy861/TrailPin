import Foundation
import CoreLocation

final class GPXImportService {

    static func importGPX(from url: URL) -> (name: String, points: [TrackPoint], waypoints: [Waypoint])? {
        guard let content = try? String(contentsOf: url, encoding: .utf8) else { return nil }
        return parseGPX(content)
    }

    private static func parseGPX(_ content: String) -> (name: String, points: [TrackPoint], waypoints: [Waypoint])? {
        var name = "Imported Track"
        var points: [TrackPoint] = []
        var waypoints: [Waypoint] = []

        let xml = content as NSString
        let range = NSRange(location: 0, length: xml.length)

        let namePattern = "<name>(.*?)</name>"
        if let nameRegex = try? NSRegularExpression(pattern: namePattern, options: []),
           let nameMatch = nameRegex.firstMatch(in: content, options: [], range: range) {
            name = xml.substring(with: nameMatch.range(at: 1))
        }

        let trkptPattern = "<trkpt\\s+lat=\"([^\"]+)\"\\s+lon=\"([^\"]+)\">.*?<ele>([^<]*)</ele>.*?<time>([^<]*)</time>.*?</trkpt>"
        if let trkptRegex = try? NSRegularExpression(pattern: trkptPattern, options: [.dotMatchesLineSeparators]) {
            let matches = trkptRegex.matches(in: content, options: [], range: range)
            for match in matches {
                guard let lat = Double(xml.substring(with: match.range(at: 1))),
                      let lon = Double(xml.substring(with: match.range(at: 2))),
                      let alt = Double(xml.substring(with: match.range(at: 3))) else { continue }
                let point = TrackPoint(latitude: lat, longitude: lon, altitude: alt)
                points.append(point)
            }
        }

        let wptPattern = "<wpt\\s+lat=\"([^\"]+)\"\\s+lon=\"([^\"]+)\">.*?<ele>([^<]*)</ele>.*?<name>([^<]*)</name>.*?</wpt>"
        if let wptRegex = try? NSRegularExpression(pattern: wptPattern, options: [.dotMatchesLineSeparators]) {
            let matches = wptRegex.matches(in: content, options: [], range: range)
            for match in matches {
                guard let lat = Double(xml.substring(with: match.range(at: 1))),
                      let lon = Double(xml.substring(with: match.range(at: 2))),
                      let alt = Double(xml.substring(with: match.range(at: 3))) else { continue }
                let wpName = xml.substring(with: match.range(at: 4))
                let waypoint = Waypoint(name: wpName, latitude: lat, longitude: lon, altitude: alt)
                waypoints.append(waypoint)
            }
        }

        return (name, points, waypoints)
    }
}
