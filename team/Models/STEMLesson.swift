import SwiftUI

struct STEMLesson: Identifiable {
    let id: String
    let title: String
    let category: String
    let iconName: String
    let color: Color
    let facts: [String]
    let question: String
    let answers: [String]
    let correctAnswerIndex: Int
    let xpReward: Int

    func displayColor(colorblindMode: Bool) -> Color {
        Self.color(for: category, colorblindMode: colorblindMode)
    }

    static func color(for category: String, colorblindMode: Bool) -> Color {
        if colorblindMode {
            switch category {
            case "Science":
                return .teal
            case "Technology":
                return .indigo
            case "Engineering":
                return .orange
            case "Math":
                return .black
            default:
                return .cyan
            }
        }

        switch category {
        case "Science":
            return .blue
        case "Technology":
            return .purple
        case "Engineering":
            return .orange
        case "Math":
            return .pink
        default:
            return .teal
        }
    }

    static let lessons: [STEMLesson] = [
        STEMLesson(
            id: "gravity-drop",
            title: "Gravity Drop",
            category: "Science",
            iconName: "drop.fill",
            color: .blue,
            facts: [
                "Gravity pulls objects toward each other.",
                "On Earth, gravity helps give objects weight.",
                "A stronger gravitational pull can speed up falling objects."
            ],
            question: "What force pulls objects toward Earth?",
            answers: ["Friction", "Gravity", "Magnetism"],
            correctAnswerIndex: 1,
            xpReward: 35
        ),
        STEMLesson(
            id: "code-loops",
            title: "Code Loops",
            category: "Technology",
            iconName: "curlybraces",
            color: .purple,
            facts: [
                "A loop repeats instructions.",
                "Loops help programmers avoid writing the same code many times.",
                "Games often use loops to update movement and animation."
            ],
            question: "Why do programmers use loops?",
            answers: ["To repeat steps", "To delete apps", "To charge batteries"],
            correctAnswerIndex: 0,
            xpReward: 40
        ),
        STEMLesson(
            id: "bridge-builders",
            title: "Bridge Builders",
            category: "Engineering",
            iconName: "hammer.fill",
            color: .orange,
            facts: [
                "Engineers test designs before building full-size structures.",
                "Triangles can make bridges stronger.",
                "A prototype helps teams improve an idea."
            ],
            question: "What is a prototype?",
            answers: ["A test version", "A type of cloud", "A finished highway"],
            correctAnswerIndex: 0,
            xpReward: 45
        ),
        STEMLesson(
            id: "fraction-fuel",
            title: "Fraction Fuel",
            category: "Math",
            iconName: "divide.circle.fill",
            color: .pink,
            facts: [
                "A fraction shows part of a whole.",
                "The denominator tells how many equal parts make the whole.",
                "The numerator tells how many parts are being counted."
            ],
            question: "In 3/4, what does 4 tell you?",
            answers: ["The number of wholes", "The equal parts in the whole", "The answer is always 4"],
            correctAnswerIndex: 1,
            xpReward: 35
        ),
        STEMLesson(
            id: "space-signals",
            title: "Space Signals",
            category: "Science",
            iconName: "antenna.radiowaves.left.and.right",
            color: .teal,
            facts: [
                "Satellites send and receive signals.",
                "Signals can carry information across long distances.",
                "GPS uses satellites to estimate location."
            ],
            question: "What can satellites send back to Earth?",
            answers: ["Signals", "Mountains", "Oceans"],
            correctAnswerIndex: 0,
            xpReward: 40
        )
    ]
}
