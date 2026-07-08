import SwiftUI

struct SparkView: View {
    enum Mood {
        case wave
        case smile
        case point
        case happy
        case celebrate
    }

    let mood: Mood
    let size: CGFloat
    let reduceMotion: Bool

    @State private var isAnimating = false

    init(mood: Mood = .smile, size: CGFloat = 120, reduceMotion: Bool = false) {
        self.mood = mood
        self.size = size
        self.reduceMotion = reduceMotion
    }

    private var rotation: Angle {
        switch mood {
        case .wave:
            return .degrees(isAnimating ? -4 : 5)
        case .point:
            return .degrees(isAnimating ? 4 : -2)
        case .celebrate:
            return .degrees(isAnimating ? 5 : -5)
        default:
            return .degrees(isAnimating ? 2 : -2)
        }
    }

    var body: some View {
        ZStack {
            wings
            bodyShape
            head
            face
            horns
            belly
            arms
            moodSymbol
        }
        .frame(width: size, height: size)
        .scaleEffect(reduceMotion ? 1 : (isAnimating ? 1.02 : 0.98))
        .rotationEffect(reduceMotion ? .zero : rotation)
        .offset(y: reduceMotion ? 0 : (isAnimating ? -4 : 4))
        .animation(reduceMotion ? nil : .easeInOut(duration: 1.7).repeatForever(autoreverses: true), value: isAnimating)
        .onAppear { isAnimating = true }
        .accessibilityLabel("Spark the baby dragon")
    }

    private var bodyShape: some View {
        VStack(spacing: -size * 0.08) {
            Spacer()
            RoundedRectangle(cornerRadius: size * 0.22)
                .fill(LinearGradient(colors: [AppTheme.purpleAccent, AppTheme.primary], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: size * 0.56, height: size * 0.54)
        }
    }

    private var head: some View {
        Circle()
            .fill(LinearGradient(colors: [AppTheme.purpleAccent.opacity(0.95), AppTheme.primary], startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(width: size * 0.62, height: size * 0.62)
            .offset(y: -size * 0.18)
    }

    private var face: some View {
        ZStack {
            HStack(spacing: size * 0.18) {
                Circle().fill(.white).frame(width: size * 0.09, height: size * 0.09)
                Circle().fill(.white).frame(width: size * 0.09, height: size * 0.09)
            }
            .overlay(
                HStack(spacing: size * 0.2) {
                    Circle().fill(AppTheme.primaryText).frame(width: size * 0.035, height: size * 0.035)
                    Circle().fill(AppTheme.primaryText).frame(width: size * 0.035, height: size * 0.035)
                }
            )
            .offset(y: -size * 0.22)

            Capsule()
                .fill(.white.opacity(0.9))
                .frame(width: size * 0.16, height: size * 0.035)
                .offset(y: -size * 0.09)
        }
    }

    private var horns: some View {
        HStack(spacing: size * 0.26) {
            Triangle()
                .fill(AppTheme.goldReward)
                .frame(width: size * 0.13, height: size * 0.18)
                .rotationEffect(.degrees(-22))
            Triangle()
                .fill(AppTheme.goldReward)
                .frame(width: size * 0.13, height: size * 0.18)
                .rotationEffect(.degrees(22))
        }
        .offset(y: -size * 0.52)
    }

    private var belly: some View {
        Capsule()
            .fill(.white.opacity(0.25))
            .frame(width: size * 0.28, height: size * 0.32)
            .offset(y: size * 0.2)
    }

    private var wings: some View {
        HStack(spacing: size * 0.38) {
            WingShape()
                .fill(AppTheme.coral.opacity(0.9))
                .frame(width: size * 0.26, height: size * 0.34)
                .rotationEffect(.degrees(-12))
            WingShape()
                .fill(AppTheme.coral.opacity(0.9))
                .frame(width: size * 0.26, height: size * 0.34)
                .scaleEffect(x: -1, y: 1)
                .rotationEffect(.degrees(12))
        }
        .offset(y: size * 0.06)
    }

    private var arms: some View {
        HStack(spacing: size * 0.42) {
            Capsule()
                .fill(AppTheme.primary)
                .frame(width: size * 0.1, height: size * 0.26)
                .rotationEffect(.degrees(mood == .wave ? -48 : -18))
            Capsule()
                .fill(AppTheme.primary)
                .frame(width: size * 0.1, height: size * 0.26)
                .rotationEffect(.degrees(mood == .point ? -62 : 18))
        }
        .offset(y: size * 0.08)
    }

    @ViewBuilder
    private var moodSymbol: some View {
        switch mood {
        case .celebrate:
            Image(systemName: "sparkles")
                .font(.system(size: size * 0.2, weight: .bold))
                .foregroundStyle(AppTheme.goldReward)
                .offset(x: size * 0.38, y: -size * 0.42)
        case .point:
            Image(systemName: "arrow.down.right.circle.fill")
                .font(.system(size: size * 0.18, weight: .bold))
                .foregroundStyle(AppTheme.goldReward)
                .offset(x: size * 0.38, y: -size * 0.18)
        case .happy:
            Image(systemName: "heart.fill")
                .font(.system(size: size * 0.14, weight: .bold))
                .foregroundStyle(AppTheme.coral)
                .offset(x: size * 0.34, y: -size * 0.34)
        default:
            EmptyView()
        }
    }
}

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

private struct WingShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.midY), control: CGPoint(x: rect.minX, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY), control: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
