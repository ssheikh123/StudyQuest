import UIKit

final class HapticManager {
    static let shared = HapticManager()

    var isEnabled = true

    private let lightImpactGenerator = UIImpactFeedbackGenerator(style: .light)
    private let mediumImpactGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let heavyImpactGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private let notificationGenerator = UINotificationFeedbackGenerator()
    private let selectionGenerator = UISelectionFeedbackGenerator()

    private init() {
        prepareGenerators()
    }

    func light() {
        guard isEnabled else { return }
        lightImpactGenerator.impactOccurred()
        lightImpactGenerator.prepare()
    }

    func medium() {
        guard isEnabled else { return }
        mediumImpactGenerator.impactOccurred()
        mediumImpactGenerator.prepare()
    }

    func heavy() {
        guard isEnabled else { return }
        heavyImpactGenerator.impactOccurred()
        heavyImpactGenerator.prepare()
    }

    func success() {
        notify(.success)
    }

    func warning() {
        notify(.warning)
    }

    func error() {
        notify(.error)
    }

    func selection() {
        guard isEnabled else { return }
        selectionGenerator.selectionChanged()
        selectionGenerator.prepare()
    }

    func prepareGenerators() {
        guard isEnabled else { return }
        lightImpactGenerator.prepare()
        mediumImpactGenerator.prepare()
        heavyImpactGenerator.prepare()
        notificationGenerator.prepare()
        selectionGenerator.prepare()
    }

    private func notify(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard isEnabled else { return }
        notificationGenerator.notificationOccurred(type)
        notificationGenerator.prepare()
    }
}
