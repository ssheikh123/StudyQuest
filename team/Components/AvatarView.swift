import SwiftUI

struct AvatarView: View {
    let skinColor: Color
    let shirtColor: Color
    let accessory: AvatarAccessory
    var hairColor: Color = Color(red: 0.16, green: 0.11, blue: 0.08)
    var reduceMotion = false
    var celebrate = false

    @State private var bounce = false
    @State private var blink = false

    var body: some View {
        ZStack {
            Circle()
                .fill(shirtColor.opacity(0.16))

            VStack(spacing: -8) {
                head
                torso
                legs
            }
            accessoryOverlay
        }
        .scaleEffect(reduceMotion ? 1 : (bounce ? 1.015 : 0.985))
        .offset(y: reduceMotion ? 0 : (bounce ? -3 : 3))
        .animation(reduceMotion ? nil : .easeInOut(duration: celebrate ? 0.45 : 1.8).repeatForever(autoreverses: true), value: bounce)
        .onAppear {
            bounce = true
            guard !reduceMotion else { return }
            Timer.scheduledTimer(withTimeInterval: 3.2, repeats: true) { _ in
                blink = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.16) { blink = false }
            }
        }
        .accessibilityLabel("Player avatar")
    }

    private var head: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 30)
                .fill(LinearGradient(colors: [skinColor.opacity(1.05), skinColor.opacity(0.78)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 108, height: 104)
                .overlay(RoundedRectangle(cornerRadius: 30).stroke(.white.opacity(0.45), lineWidth: 2))

            RoundedRectangle(cornerRadius: 24)
                .fill(hairColor)
                .frame(width: 100, height: 38)
                .offset(y: -6)

            HStack(spacing: 24) {
                eye
                eye
            }
            .offset(y: 42)

            Capsule()
                .fill(Color.black.opacity(0.72))
                .frame(width: 32, height: 7)
                .offset(y: 70)
        }
    }

    private var eye: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(.black)
            .frame(width: 12, height: blink ? 3 : 16)
            .overlay(Circle().fill(.white).frame(width: 4, height: 4).offset(x: -2, y: -3), alignment: .topLeading)
    }

    private var torso: some View {
        ZStack {
            HStack(spacing: 84) {
                Capsule().fill(skinColor).frame(width: 18, height: 52).rotationEffect(.degrees(12))
                Capsule().fill(skinColor).frame(width: 18, height: 52).rotationEffect(.degrees(-12))
            }
            RoundedRectangle(cornerRadius: 24)
                .fill(LinearGradient(colors: [shirtColor, shirtColor.opacity(0.75)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 96, height: 86)
                .overlay(Image(systemName: "star.fill").font(.title2.weight(.bold)).foregroundStyle(.white.opacity(0.85)))
        }
    }

    private var legs: some View {
        HStack(spacing: 18) {
            Capsule().fill(shirtColor.opacity(0.9)).frame(width: 24, height: 36)
            Capsule().fill(shirtColor.opacity(0.9)).frame(width: 24, height: 36)
        }
    }

    @ViewBuilder
    private var accessoryOverlay: some View {
        switch accessory {
        case .stars:
            Image(systemName: "sparkles").font(.title.weight(.bold)).foregroundStyle(AppTheme.goldReward).offset(x: 52, y: -58)
        case .goggles:
            Image(systemName: "eyeglasses").font(.largeTitle.weight(.bold)).foregroundStyle(.black).offset(y: -28)
        case .bolt:
            Image(systemName: "bolt.fill").font(.title.weight(.bold)).foregroundStyle(.orange).offset(x: 52, y: -42)
        case .rocket:
            Image(systemName: "paperplane.fill").font(.title.weight(.bold)).foregroundStyle(.red).offset(x: 50, y: -48)
        }
    }
}
