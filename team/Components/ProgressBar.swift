import SwiftUI

struct ProgressBar: View {
    let value: Double
    let tint: Color
    var backgroundOpacity = 0.16
    var minimumFillWidth: CGFloat = 10

    private var clampedValue: Double {
        min(max(value, 0), 1)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(tint.opacity(backgroundOpacity))
                Capsule()
                    .fill(tint)
                    .frame(width: max(minimumFillWidth, geometry.size.width * clampedValue))
            }
        }
    }
}
