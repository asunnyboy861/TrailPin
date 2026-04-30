import SwiftUI

struct BatteryIndicator: View {
    let optimizer: BatteryOptimizer

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: optimizer.batteryIcon)
                .foregroundStyle(batteryColor)
            Text("\(Int(optimizer.batteryLevel * 100))%")
                .font(.caption2.monospacedDigit())
            Image(systemName: optimizer.currentMode.icon)
                .font(.caption2)
                .foregroundStyle(Color("ForestGreen"))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
    }

    private var batteryColor: Color {
        if optimizer.batteryLevel >= 0.3 { return .green }
        if optimizer.batteryLevel >= 0.15 { return .yellow }
        return .red
    }
}
