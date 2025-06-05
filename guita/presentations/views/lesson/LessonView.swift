//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct LessonView: View {
  let songInfo: SongInfo
  @EnvironmentObject var router: Router

  var body: some View {
    BaseView(
      create: { LessonViewModel() }
    ) { _, _ in
      VStack {
        // MARK: Toolbar
        Toolbar(title: songInfo.level, accessibilityText: "The song title is \(songInfo.title), and it uses the chords \(songInfo.chords). You can choose to study chord lessons, technique lessons, section lessons, or the full song lesson. Swipe left or right to select the lesson you want.")

        Spacer()

        // MARK: SongTitle & Code
        VStack {
          VStack {
            Text(songInfo.title)
              .fontKoddi(26, color: .light, weight: .bold)
              .accessibilityHidden(true)
              .padding(.bottom, 6)

            Text(songInfo.chords.map { "\($0.rawValue)" }.joined(separator: ", "))
              .fontKoddi(18, color: .darkGrey, weight: .regular)
              .accessibilityHidden(true)
          }
          .frame(maxWidth: .infinity, maxHeight: 220)

          // MARK: Learning Buttons
          GeometryReader { geometry in
            let boxWidth = geometry.size.width
            let boxHeight = geometry.size.height / 4

            LazyVStack(spacing: 0) {
              ListDivider()

              Button(action: {
                router.push(.chord(songInfo: songInfo))
              }) {
                Text("Chord Lesson")
                  .fontKoddi(26, color: .light, weight: .regular)
                  .frame(width: boxWidth, height: boxHeight)
                  .accessibilityAddTraits(.isButton)
                  .accessibilityLabel("Start chord lesson")
              }
              ListDivider()

              Button(action: {
                router.push(.techniqueLesson) // 임시로 라우팅 해둠
              }) {
                Text("Technique Lesson")
                  .fontKoddi(26, color: .light, weight: .regular)
                  .frame(width: boxWidth, height: boxHeight)
                  .accessibilityAddTraits(.isButton)
                  .accessibilityLabel("Start technique lesson")
              }
              ListDivider()
              Button(action: {
                router.push(.sectionLesson)
              }) {
                Text("Section Lesson")
                  .fontKoddi(26, color: .light, weight: .regular)
                  .frame(width: boxWidth, height: boxHeight)
                  .accessibilityAddTraits(.isButton)
                  .accessibilityLabel("Start section lesson")
              }
              ListDivider()
              Button(action: {
                router.push(.fullLesson(songInfo: songInfo))
              }) {
                Text("Full Song Lesson")
                  .fontKoddi(26, color: .light, weight: .regular)
                  .frame(width: boxWidth, height: boxHeight)
                  .accessibilityAddTraits(.isButton)
                  .accessibilityLabel("Start full song lesson")
              }
              ListDivider()
            }
          }
        }
      }
    }
  }
}

#Preview {
  BasePreview {
    LessonView(songInfo: SongInfo.curriculum.first!)
  }
}
