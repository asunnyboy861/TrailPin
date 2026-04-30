import SwiftUI

struct GPSSignalView: View {
    let strength: LocationManager.GPSSignalStrength

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: strength.icon)
                .foregroundStyle(signalColor)
            Text(signalText)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
    }

    private var signalColor: Color {
        switch strength {
        case .searching: return .gray
        case .weak: return .yellow
        case .strong: return .green
        }
    }

    private var signalText: String {
        switch strength {
        case .searching: return "Searching..."
        case .weak: return "Weak GPS"
        case .strong: return "GPS"
        }
    }
}
