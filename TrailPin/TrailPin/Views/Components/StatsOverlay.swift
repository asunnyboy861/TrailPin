import SwiftUI

struct StatsOverlay: View {
    let distance: String
    let time: String
    let speed: String
    let elevationGain: String
    let elevationLoss: String
    let isRecording: Bool
    let isPaused: Bool

    var body: some View {
        VStack(spacing: 8) {
            if isRecording && !isPaused {
                HStack(spacing: 6) {
                    Circle()
                        .fill(.red)
                        .frame(width: 8, height: 8)
                    Text("Recording")
                        .font(.caption.bold())
                        .foregroundStyle(.red)
                }
            }

            HStack(spacing: 20) {
                StatItem(label: "Distance", value: distance)
                StatItem(label: "Time", value: time)
                StatItem(label: "Speed", value: speed)
            }

            HStack(spacing: 20) {
                StatItem(label: "Elevation +", value: elevationGain)
                StatItem(label: "Elevation -", value: elevationLoss)
            }
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct StatItem: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(.title3, design: .monospaced).bold())
                .contentTransition(.numericText())
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
