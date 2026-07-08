import SwiftUI

struct LessonsHomeView: View {
    let xp: Int
    let level: Int
    let progress: LessonProgress
    let settings: AppAccessibilitySettings
    @Binding var downloadData: DownloadData
    let startLesson: (Lesson) -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    HeaderBand(xp: xp, level: level, settings: settings)

                    NavigationLink {
                        DownloadsView(
                            settings: settings,
                            downloadData: $downloadData,
                            startLesson: startLesson
                        )
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: "arrow.down.circle.fill")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(width: 56, height: 56)
                                .background(AppTheme.greenSuccess.gradient)
                                .clipShape(RoundedRectangle(cornerRadius: 18))

                            VStack(alignment: .leading, spacing: 5) {
                                Text("Downloads")
                                    .font(.studyQuest(.headline, weight: .bold))
                                    .foregroundStyle(settings.primaryText)
                                Text("\(downloadData.downloadedLessonIDs.count) lessons available offline")
                                    .font(.studyQuest(.subheadline, weight: .semibold))
                                    .foregroundStyle(settings.secondaryText)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.headline.weight(.bold))
                                .foregroundStyle(settings.secondaryText)
                        }
                        .padding(16)
                        .studyQuestCard(settings: settings)
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 18)

                    Text("Learning Paths")
                        .font(.title2.weight(.bold))
                        .padding(.horizontal, 18)

                    LazyVStack(spacing: 14) {
                        ForEach(CurriculumData.subjects) { subject in
                            NavigationLink {
                                DifficultySelectionView(
                                    subject: subject,
                                    progress: progress,
                                    settings: settings,
                                    downloadData: $downloadData,
                                    startLesson: startLesson
                                )
                            } label: {
                                SubjectCard(
                                    subject: subject,
                                    completedCount: progress.completedCount(in: subject, difficulty: .beginner),
                                    settings: settings
                                )
                            }
                            .buttonStyle(.plain)
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
