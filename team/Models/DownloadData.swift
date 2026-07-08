import Foundation

struct DownloadData: Codable, Equatable {
    var downloadedLessonIDs: Set<String> = []
}
