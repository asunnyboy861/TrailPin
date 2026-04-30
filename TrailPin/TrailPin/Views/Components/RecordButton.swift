import SwiftUI

struct RecordButton: View {
    let isRecording: Bool
    let isPaused: Bool
    let action: () -> Void

    @State private var isPulsing = false

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(backgroundColor)
                    .frame(width: 72, height: 72)
                    .overlay(
                        Circle()
                            .stroke(borderColor, lineWidth: 3)
                    )

                Image(systemName: iconName)
                    .font(.title)
                    .foregroundStyle(.white)
            }
        }
        .scaleEffect(isPulsing ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isPulsing)
        .onAppear {
            if !isRecording {
                isPulsing = true
            }
        }
    }

    private var backgroundColor: Color {
        if isRecording && !isPaused { return .red }
        if isPaused { return Color("WarmOrange") }
        return Color("ForestGreen")
    }

    private var borderColor: Color {
        if isRecording && !isPaused { return .red.opacity(0.5) }
        if isPaused { return Color("WarmOrange").opacity(0.5) }
        return Color("ForestGreen").opacity(0.5)
    }

    private var iconName: String {
        if isRecording && !isPaused { return "stop.fill" }
        if isPaused { return "pause.fill" }
        return "play.fill"
    }
}
