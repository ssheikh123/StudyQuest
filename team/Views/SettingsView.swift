import SwiftUI

struct SettingsView: View {
    @Binding var settings: AppAccessibilitySettings

    var body: some View {
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
