//
//  ContentView.swift
//  team
//
//  Created by sermacbook_02 on 7/1/26.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var xp = 0
    @State private var completedLessonIDs = Set<String>()
    @State private var activeLesson: STEMLesson?
    @State private var avatarColor = AvatarColor.sky
    @State private var avatarAccessory = AvatarAccessory.stars
    @State private var accessibilitySettings = AppAccessibilitySettings()
    @State private var hasFinishedLaunch = false

    private var level: Int {
        xp / 100 + 1
    }

    var body: some View {
        ZStack {
            if hasFinishedLaunch {
                mainAppView
                    .transition(accessibilitySettings.reduceMotion ? .identity : .opacity)
                    .overlay(alignment: .topLeading) {
                        Button(action: returnToLaunchScreen) {
                            Image(systemName: "arrow.left")
                                .font(.headline.weight(.bold))
                                .frame(width: 44, height: 44)
                                .background(.regularMaterial)
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Back to launch screen")
                        .padding(.top, 8)
                        .padding(.leading, 12)
                    }
            } else {
                LaunchScreenView(
                    avatarColor: avatarColor,
                    avatarAccessory: avatarAccessory,
                    settings: accessibilitySettings,
                    start: startApp
                )
                .transition(accessibilitySettings.reduceMotion ? .identity : .opacity)
            }
        }
        .tint(accessibilitySettings.accentColor)
        .preferredColorScheme(accessibilitySettings.darkMode ? .dark : nil)
        .dynamicTypeSize(accessibilitySettings.largerText ? .accessibility2 : .large)
        .contrast(accessibilitySettings.highContrast ? 1.2 : 1.0)
        .transaction { transaction in
            if accessibilitySettings.reduceMotion {
                transaction.disablesAnimations = true
            }
        }
        .sheet(item: $activeLesson) { lesson in
            LessonDetailView(
                lesson: lesson,
                isCompleted: completedLessonIDs.contains(lesson.id),
                settings: accessibilitySettings,
                close: { activeLesson = nil },
                completeLesson: {
                    if !completedLessonIDs.contains(lesson.id) {
                        completedLessonIDs.insert(lesson.id)
                        xp += lesson.xpReward
                    }
                }
            )
        }
    }

    private var mainAppView: some View {
        TabView(selection: $selectedTab) {
            LessonsHomeView(
                xp: xp,
                level: level,
                completedLessonIDs: completedLessonIDs,
                settings: accessibilitySettings,
                startLesson: { lesson in activeLesson = lesson }
            )
            .tabItem {
                Label("Lessons", systemImage: "book.closed.fill")
            }
            .tag(0)

            AvatarStudioView(
                xp: xp,
                level: level,
                settings: accessibilitySettings,
                selectedColor: $avatarColor,
                selectedAccessory: $avatarAccessory
            )
            .tabItem {
                Label("Avatar", systemImage: "person.crop.circle.fill")
            }
            .tag(1)

            ProgressDashboardView(
                xp: xp,
                level: level,
                completedCount: completedLessonIDs.count,
                totalLessons: STEMLesson.lessons.count,
                avatarColor: avatarColor,
                avatarAccessory: avatarAccessory,
                settings: accessibilitySettings
            )
            .tabItem {
                Label("Progress", systemImage: "chart.bar.fill")
            }
            .tag(2)

            SettingsView(settings: $accessibilitySettings)
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(3)
        }
    }

    private func startApp() {
        withAnimation(accessibilitySettings.reduceMotion ? nil : .easeInOut(duration: 0.35)) {
            hasFinishedLaunch = true
        }
    }

    private func returnToLaunchScreen() {
        activeLesson = nil

        withAnimation(accessibilitySettings.reduceMotion ? nil : .easeInOut(duration: 0.35)) {
            hasFinishedLaunch = false
        }
    }
}

private struct AppAccessibilitySettings {
    var darkMode = false
    var colorblindMode = false
    var largerText = false
    var textToSpeech = false
    var highContrast = false
    var reduceMotion = false
    var buttonLabels = true

    var accentColor: Color {
        colorblindMode ? .orange : .purple
    }

    var screenBackground: Color {
        darkMode ? .black : Color(red: 0.96, green: 0.97, blue: 1.0)
    }

    var alternateScreenBackground: Color {
        darkMode ? .black : Color(red: 0.95, green: 0.98, blue: 0.97)
    }

    var cardBackground: Color {
        darkMode ? Color(red: 0.04, green: 0.04, blue: 0.05) : Color(.secondarySystemGroupedBackground)
    }
}

private struct LaunchScreenView: View {
    let avatarColor: AvatarColor
    let avatarAccessory: AvatarAccessory
    let settings: AppAccessibilitySettings
    let start: () -> Void

    var body: some View {
        ZStack {
            launchBackground

            VStack(spacing: 26) {
                ZStack {
                    Circle()
                        .fill(.white.opacity(settings.darkMode ? 0.12 : 0.22))
                        .frame(width: 132, height: 132)

                    Image(systemName: "atom")
                        .font(.system(size: 66, weight: .bold))
                        .foregroundStyle(.white)
                }

                VStack(spacing: 8) {
                    Text("StudyQuest")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Text("STEM learning for curious minds")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.86))
                        .multilineTextAlignment(.center)
                }

                AvatarPreview(color: avatarColor.color, accessory: avatarAccessory)
                    .frame(width: 168, height: 168)
                    .background(.white.opacity(settings.darkMode ? 0.08 : 0.16))
                    .clipShape(Circle())
                    .accessibilityLabel("User avatar")

                Button(action: start) {
                    Label("Start Learning", systemImage: "play.fill")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(settings.accentColor)
                        .frame(maxWidth: 260)
                        .padding(.vertical, 16)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .accessibilityLabel("Start Learning")
            }
            .padding(28)
        }
        .ignoresSafeArea()
    }

    private var launchBackground: some View {
        LinearGradient(
            colors: settings.colorblindMode
                ? [Color.orange, Color.teal, Color.indigo]
                : [Color.purple, Color.blue, Color.cyan],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .overlay(settings.darkMode ? Color.black.opacity(0.28) : Color.clear)
    }
}

private struct LessonsHomeView: View {
    let xp: Int
    let level: Int
    let completedLessonIDs: Set<String>
    let settings: AppAccessibilitySettings
    let startLesson: (STEMLesson) -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    HeaderBand(xp: xp, level: level, settings: settings)

                    Text("STEM Lessons")
                        .font(.title2.weight(.bold))
                        .padding(.horizontal, 18)

                    LazyVStack(spacing: 14) {
                        ForEach(STEMLesson.lessons) { lesson in
                            LessonCard(
                                lesson: lesson,
                                isCompleted: completedLessonIDs.contains(lesson.id),
                                settings: settings,
                                startLesson: { startLesson(lesson) }
                            )
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.bottom, 24)
                }
            }
            .background(settings.screenBackground)
            .navigationTitle("StudyQuest")
        }
    }
}

private struct HeaderBand: View {
    let xp: Int
    let level: Int
    let settings: AppAccessibilitySettings

    private var progress: Double {
        Double(xp % 100) / 100
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .center, spacing: 14) {
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.25))
                    Image(systemName: "atom")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundStyle(.white)
                }
                .frame(width: 82, height: 82)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Level \(level)")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(.white)
                    Text("\(xp) XP earned")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.88))
                }

                Spacer()
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Next level")
                    Spacer()
                    Text("\(xp % 100)/100 XP")
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(.white.opacity(0.25))
                        Capsule()
                            .fill(.white)
                            .frame(width: max(12, geometry.size.width * progress))
                    }
                }
                .frame(height: 12)
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: settings.colorblindMode ? [Color.orange, Color.teal, Color.indigo] : [Color.purple, Color.blue, Color.cyan],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

private struct LessonCard: View {
    let lesson: STEMLesson
    let isCompleted: Bool
    let settings: AppAccessibilitySettings
    let startLesson: () -> Void

    private var lessonColor: Color {
        lesson.displayColor(colorblindMode: settings.colorblindMode)
    }

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(lessonColor.opacity(0.18))
                Image(systemName: lesson.iconName)
                    .font(.title.weight(.bold))
                    .foregroundStyle(lessonColor)
            }
            .frame(width: 64, height: 64)

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text(lesson.category)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(lessonColor)
                    if isCompleted {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(.green)
                    }
                }

                Text(lesson.title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text("\(lesson.xpReward) XP")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button(action: startLesson) {
                if settings.buttonLabels {
                    Label(isCompleted ? "Retake" : "Start", systemImage: isCompleted ? "arrow.clockwise" : "play.fill")
                        .font(.headline.weight(.bold))
                        .frame(minWidth: 74, minHeight: 44)
                } else {
                    Image(systemName: isCompleted ? "arrow.clockwise" : "play.fill")
                        .font(.headline.weight(.bold))
                        .frame(width: 44, height: 44)
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(lessonColor)
            .accessibilityLabel(isCompleted ? "Retake lesson" : "Start lesson")
        }
        .padding(14)
        .background(settings.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 5)
    }
}

private struct LessonDetailView: View {
    let lesson: STEMLesson
    let isCompleted: Bool
    let settings: AppAccessibilitySettings
    let close: () -> Void

    private var lessonColor: Color {
        lesson.displayColor(colorblindMode: settings.colorblindMode)
    }
    let completeLesson: () -> Void

    @State private var selectedAnswerIndex: Int?
    @State private var feedbackText = "Pick an answer to finish the lesson."
    @State private var didAnswerCorrectly = false
    @State private var speechSynthesizer = AVSpeechSynthesizer()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ZStack(alignment: .bottomLeading) {
                        lessonColor
                        VStack(alignment: .leading, spacing: 10) {
                            Image(systemName: lesson.iconName)
                                .font(.system(size: 52, weight: .bold))
                                .foregroundStyle(.white)
                            Text(lesson.title)
                                .font(.largeTitle.weight(.bold))
                                .foregroundStyle(.white)
                            Text("Earn \(lesson.xpReward) XP")
                                .font(.headline)
                                .foregroundStyle(.white.opacity(0.9))
                        }
                        .padding(22)
                    }
                    .frame(height: 220)

                    VStack(alignment: .leading, spacing: 14) {
                        Text("Mini Lesson")
                            .font(.title3.weight(.bold))

                        ForEach(lesson.facts, id: \.self) { fact in
                            Label(fact, systemImage: "sparkle")
                                .font(.body)
                                .foregroundStyle(.primary)
                        }
                    }
                    .padding(.horizontal, 20)

                    VStack(alignment: .leading, spacing: 12) {
                        Text(lesson.question)
                            .font(.title3.weight(.bold))

                        ForEach(lesson.answers.indices, id: \.self) { index in
                            AnswerButton(
                                title: lesson.answers[index],
                                isSelected: selectedAnswerIndex == index,
                                color: lessonColor,
                                action: { selectedAnswerIndex = index }
                            )
                        }

                        Text(feedbackText)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(didAnswerCorrectly ? .green : .secondary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 22)
                }
            }
            .background(settings.screenBackground)
            .navigationTitle(lesson.category)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close", action: close)
                }
                if settings.textToSpeech {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: speakLesson) {
                            Label("Speak", systemImage: "speaker.wave.2.fill")
                        }
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(isCompleted || didAnswerCorrectly ? "Done" : "Submit") {
                        submitAnswer()
                    }
                    .disabled(selectedAnswerIndex == nil && !didAnswerCorrectly && !isCompleted)
                }
            }
        }
    }

    private func speakLesson() {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
            return
        }

        let lessonText = ([lesson.title] + lesson.facts + [lesson.question]).joined(separator: ". ")
        let utterance = AVSpeechUtterance(string: lessonText)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speak(utterance)
    }

    private func submitAnswer() {
        if isCompleted || didAnswerCorrectly {
            close()
            return
        }

        guard let selectedAnswerIndex else { return }

        if selectedAnswerIndex == lesson.correctAnswerIndex {
            didAnswerCorrectly = true
            feedbackText = "Correct! XP added to your profile."
            completeLesson()
        } else {
            feedbackText = "Not quite. Try another answer."
        }
    }
}

private struct AnswerButton: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .foregroundStyle(isSelected ? color : .secondary)
            }
            .padding(14)
            .background(isSelected ? color.opacity(0.16) : .white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? color : .clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

private struct AvatarStudioView: View {
    let xp: Int
    let level: Int
    let settings: AppAccessibilitySettings
    @Binding var selectedColor: AvatarColor
    @Binding var selectedAccessory: AvatarAccessory

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    VStack(spacing: 14) {
                        AvatarPreview(color: selectedColor.color, accessory: selectedAccessory)
                            .frame(width: 190, height: 190)

                        Text("Level \(level) Explorer")
                            .font(.title2.weight(.bold))

                        Text("\(xp) XP unlocks your science style.")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(22)
                    .background(settings.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                    CustomizerSection(title: "Avatar Color") {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 72), spacing: 12)], spacing: 12) {
                            ForEach(AvatarColor.allCases) { colorChoice in
                                ColorChoiceButton(
                                    colorChoice: colorChoice,
                                    isSelected: selectedColor == colorChoice,
                                    action: { selectedColor = colorChoice }
                                )
                            }
                        }
                    }

                    CustomizerSection(title: "Accessory") {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 104), spacing: 12)], spacing: 12) {
                            ForEach(AvatarAccessory.allCases) { accessory in
                                AccessoryChoiceButton(
                                    accessory: accessory,
                                    isSelected: selectedAccessory == accessory,
                                    action: { selectedAccessory = accessory }
                                )
                            }
                        }
                    }
                }
                .padding(18)
            }
            .background(settings.alternateScreenBackground)
            .navigationTitle("Avatar Studio")
        }
    }
}

private struct CustomizerSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.title3.weight(.bold))
            content
        }
        .padding(18)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct ColorChoiceButton: View {
    let colorChoice: AvatarColor
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Circle()
                    .fill(colorChoice.color)
                    .frame(width: 42, height: 42)
                    .overlay(
                        Circle()
                            .stroke(isSelected ? Color.primary : Color.clear, lineWidth: 3)
                    )
                Text(colorChoice.rawValue)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

private struct AccessoryChoiceButton: View {
    let accessory: AvatarAccessory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: accessory.iconName)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(isSelected ? Color.white : accessory.color)
                    .frame(width: 50, height: 50)
                    .background(isSelected ? accessory.color : accessory.color.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                Text(accessory.rawValue)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }
}

private struct AvatarPreview: View {
    let color: Color
    let accessory: AvatarAccessory

    var body: some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.22))

            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    Circle()
                        .fill(color)
                        .frame(width: 104, height: 104)

                    Image(systemName: accessory.iconName)
                        .font(.title.weight(.bold))
                        .foregroundStyle(accessory.color)
                        .offset(y: -18)

                    HStack(spacing: 22) {
                        Circle().fill(.black).frame(width: 9, height: 9)
                        Circle().fill(.black).frame(width: 9, height: 9)
                    }
                    .offset(y: 42)

                    Capsule()
                        .fill(.black.opacity(0.75))
                        .frame(width: 34, height: 7)
                        .offset(y: 66)
                }

                RoundedRectangle(cornerRadius: 8)
                    .fill(color)
                    .frame(width: 132, height: 76)
                    .overlay(
                        Image(systemName: "atom")
                            .font(.title.weight(.bold))
                            .foregroundStyle(.white.opacity(0.9))
                    )
            }
        }
    }
}

private struct ProgressDashboardView: View {
    let xp: Int
    let level: Int
    let completedCount: Int
    let totalLessons: Int
    let avatarColor: AvatarColor
    let avatarAccessory: AvatarAccessory
    let settings: AppAccessibilitySettings

    private var completionProgress: Double {
        guard totalLessons > 0 else { return 0 }
        return Double(completedCount) / Double(totalLessons)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        AvatarPreview(color: avatarColor.color, accessory: avatarAccessory)
                            .frame(width: 110, height: 110)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Level \(level)")
                                .font(.title.weight(.bold))
                            Text("\(xp) total XP")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                            Text("\(completedCount) of \(totalLessons) lessons complete")
                                .font(.subheadline.weight(.semibold))
                        }

                        Spacer()
                    }
                    .padding(18)
                    .background(settings.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                    SkillProgressRow(title: "Lesson Progress", value: completionProgress, color: settings.colorblindMode ? .teal : .green)
                    SkillProgressRow(title: "Science", value: skillValue(for: "Science"), color: STEMLesson.color(for: "Science", colorblindMode: settings.colorblindMode))
                    SkillProgressRow(title: "Technology", value: skillValue(for: "Technology"), color: STEMLesson.color(for: "Technology", colorblindMode: settings.colorblindMode))
                    SkillProgressRow(title: "Engineering", value: skillValue(for: "Engineering"), color: STEMLesson.color(for: "Engineering", colorblindMode: settings.colorblindMode))
                    SkillProgressRow(title: "Math", value: skillValue(for: "Math"), color: STEMLesson.color(for: "Math", colorblindMode: settings.colorblindMode))
                }
                .padding(18)
            }
            .background(settings.screenBackground)
            .navigationTitle("Progress")
        }
    }

    private func skillValue(for category: String) -> Double {
        let lessonsInCategory = STEMLesson.lessons.filter { $0.category == category }.count
        guard lessonsInCategory > 0 else { return 0 }
        let completedEstimate = min(completedCount, lessonsInCategory)
        return Double(completedEstimate) / Double(lessonsInCategory)
    }
}

private struct SkillProgressRow: View {
    let title: String
    let value: Double
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Text("\(Int(value * 100))%")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(color)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(color.opacity(0.16))
                    Capsule()
                        .fill(color)
                        .frame(width: max(10, geometry.size.width * value))
                }
            }
            .frame(height: 14)
        }
        .padding(18)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct SettingsView: View {
    @Binding var settings: AppAccessibilitySettings

    var body: some View {
        NavigationStack {
            Form {
                Section("Visual") {
                    Toggle(isOn: $settings.darkMode) {
                        Label("Dark Mode", systemImage: "moon.fill")
                    }
                    Toggle(isOn: $settings.colorblindMode) {
                        Label("Colorblind Mode", systemImage: "eye.fill")
                    }
                    Toggle(isOn: $settings.highContrast) {
                        Label("High Contrast", systemImage: "circle.lefthalf.filled")
                    }
                    Toggle(isOn: $settings.largerText) {
                        Label("Larger Text", systemImage: "textformat.size")
                    }
                }

                Section("Reading") {
                    Toggle(isOn: $settings.textToSpeech) {
                        Label("Text to Speech", systemImage: "speaker.wave.2.fill")
                    }
                    Toggle(isOn: $settings.buttonLabels) {
                        Label("Helpful Button Labels", systemImage: "character.cursor.ibeam")
                    }
                }

                Section("Interaction") {
                    Toggle(isOn: $settings.reduceMotion) {
                        Label("Reduce Motion", systemImage: "figure.walk.motion")
                    }
                }

                Section("Preview") {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Accessibility Preview")
                            .font(.headline)
                        Text("Settings update the whole app, including lesson colors, text size, contrast, and speech tools.")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 6)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

private struct STEMLesson: Identifiable {
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

private enum AvatarColor: String, CaseIterable, Identifiable {
    case sky = "Sky"
    case mint = "Mint"
    case coral = "Coral"
    case violet = "Violet"
    case gold = "Gold"
    case navy = "Navy"

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .sky:
            return Color(red: 0.22, green: 0.58, blue: 0.95)
        case .mint:
            return Color(red: 0.10, green: 0.72, blue: 0.52)
        case .coral:
            return Color(red: 0.96, green: 0.36, blue: 0.30)
        case .violet:
            return Color(red: 0.50, green: 0.32, blue: 0.88)
        case .gold:
            return Color(red: 0.94, green: 0.64, blue: 0.10)
        case .navy:
            return Color(red: 0.13, green: 0.20, blue: 0.38)
        }
    }
}

private enum AvatarAccessory: String, CaseIterable, Identifiable {
    case stars = "Stars"
    case goggles = "Goggles"
    case bolt = "Bolt"
    case rocket = "Rocket"

    var id: String { rawValue }

    var iconName: String {
        switch self {
        case .stars:
            return "sparkles"
        case .goggles:
            return "eyeglasses"
        case .bolt:
            return "bolt.fill"
        case .rocket:
            return "paperplane.fill"
        }
    }

    var color: Color {
        switch self {
        case .stars:
            return .yellow
        case .goggles:
            return .black
        case .bolt:
            return .orange
        case .rocket:
            return .red
        }
    }
}

#Preview {
    ContentView()
}
