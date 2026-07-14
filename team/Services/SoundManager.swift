import AVFoundation
import Foundation

enum AppSound: String, CaseIterable {
    case buttonTap
    case success
    case error
    case coin
    case xp
    case levelUp
    case badge
    case purchase
    case questComplete
    case reward
    case whoosh
    case pop

    var fileName: String { rawValue }

    var fileExtensions: [String] {
        ["wav", "mp3"]
    }
}

final class SoundManager {
    static let shared = SoundManager()

    var isEnabled = true

    private var players: [AppSound: AVAudioPlayer] = [:]

    private init() {
        preloadSounds()
    }

    func play(_ sound: AppSound) {
        guard isEnabled else { return }

        guard let player = player(for: sound) else {
            return
        }

        if player.isPlaying {
            player.stop()
        }
        player.currentTime = 0
        player.play()
    }

    private func preloadSounds() {
        for sound in AppSound.allCases {
            _ = player(for: sound)
        }
    }

    private func player(for sound: AppSound) -> AVAudioPlayer? {
        if let player = players[sound] {
            return player
        }

        guard let url = soundURL(for: sound),
              let player = try? AVAudioPlayer(contentsOf: url) else {
            return nil
        }

        player.prepareToPlay()
        players[sound] = player
        return player
    }

    private func soundURL(for sound: AppSound) -> URL? {
        for fileExtension in sound.fileExtensions {
            if let url = Bundle.main.url(
                forResource: sound.fileName,
                withExtension: fileExtension,
                subdirectory: "Sounds"
            ) {
                return url
            }

            if let url = Bundle.main.url(
                forResource: sound.fileName,
                withExtension: fileExtension,
                subdirectory: "Resources/Sounds"
            ) {
                return url
            }

            if let url = Bundle.main.url(forResource: sound.fileName, withExtension: fileExtension) {
                return url
            }
        }

        return nil
    }
}
