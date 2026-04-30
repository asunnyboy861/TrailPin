import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var gpx: UTType {
        UTType(filenameExtension: "gpx") ?? .xml
    }
}
