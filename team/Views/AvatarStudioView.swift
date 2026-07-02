import SwiftUI

struct AvatarStudioView: View {
    let xp: Int
    let level: Int
    let settings: AppAccessibilitySettings
    @Binding var selectedColor: AvatarColor
    @Binding var selectedAccessory: AvatarAccessory

    var body: some View {
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
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))

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
