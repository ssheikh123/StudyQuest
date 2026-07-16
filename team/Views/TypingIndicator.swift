import SwiftUI

struct TypingIndicator: View {
    let settings: AppAccessibilitySettings
    @State private var phase = 0

    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(settings.secondaryText)
                    .frame(width: 7, height: 7)
                    .opacity(phase == index ? 1 : 0.35)
                    .scaleEffect(phase == index ? 1.18 : 1)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(AppTheme.cardBackground(darkMode: settings.darkMode))
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(settings.darkMode ? Color.white.opacity(0.08) : Color.black.opacity(0.04), lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear {
            guard !settings.reduceMotion else { return }
            Timer.scheduledTimer(withTimeInterval: 0.28, repeats: true) { _ in
                phase = (phase + 1) % 3
            }
        }
        .accessibilityLabel("AI tutor is typing")
    }
}
