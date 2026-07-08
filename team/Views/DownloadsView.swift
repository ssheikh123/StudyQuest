import SwiftUI

struct DownloadsView: View {
    let settings: AppAccessibilitySettings
    @Binding var downloadData: DownloadData
    let startLesson: (Lesson) -> Void

    private var downloadedLessons: [Lesson] {
        DownloadManager.downloadedLessons(data: downloadData)
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                if downloadedLessons.isEmpty {
                    SparkTipCard(
                        message: "Downloaded lessons will appear here so you can find offline practice quickly.",
                        settings: settings
                    )
                } else {
                    ForEach(downloadedLessons) { lesson in
                        DownloadedLessonRow(
                            lesson: lesson,
                            settings: settings,
                            removeDownload: {
                                DownloadManager.removeDownload(lesson, data: &downloadData)
                            },
                            startLesson: {
                                startLesson(lesson)
                            }
                        )
                    }
                }
            }
            .padding(18)
        }
        .background(settings.screenBackground)
        .navigationTitle("Downloads")
    }
}
