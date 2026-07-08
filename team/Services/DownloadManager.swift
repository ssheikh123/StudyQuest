import Foundation

enum DownloadManager {
    static func isDownloaded(_ lesson: Lesson, data: DownloadData) -> Bool {
        data.downloadedLessonIDs.contains(lesson.id)
    }

    static func markDownloaded(_ lesson: Lesson, data: inout DownloadData) {
        data.downloadedLessonIDs.insert(lesson.id)
    }

    static func removeDownload(_ lesson: Lesson, data: inout DownloadData) {
        data.downloadedLessonIDs.remove(lesson.id)
    }

    static func downloadedLessons(data: DownloadData, subjects: [Subject] = CurriculumData.subjects) -> [Lesson] {
        subjects
            .flatMap(\.lessons)
            .filter { data.downloadedLessonIDs.contains($0.id) }
            .sorted { lhs, rhs in
                if lhs.subjectTitle == rhs.subjectTitle {
                    return lhs.order < rhs.order
                }
                return lhs.subjectTitle < rhs.subjectTitle
            }
    }
}
