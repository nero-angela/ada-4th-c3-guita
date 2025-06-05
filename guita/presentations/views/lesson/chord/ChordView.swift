//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct ChordView: View {
  @EnvironmentObject var router: Router
//  @AccessibilityFocusState private var focusedChord: Chord?

  let songInfo: SongInfo

  var body: some View {
    BaseView(
      create: { ChordViewModel(songInfo) }
    ) { _, state in
      VStack(spacing: 0) {
        // MARK: Toolbar
        Toolbar(title: "Chord Lesson", accessibilityText: "This screen is for learning \(state.songInfo.chords). Please pick the chord you want to learn with your guitar.")

        // MARK: Chord Button
        ListDivider()
          .padding(.top, 32)
        ForEach(state.songInfo.chords, id: \.self) { chord in
          Button(action: { router.push(.chordLesson(chord: chord, chords: state.songInfo.chords)) }) {
            VStack {
              Text("\(chord.rawValue) Chord")
                .fontKoddi(26, color: .darkGrey, weight: .bold)
                .padding(.vertical, 36)
            }
            .frame(maxWidth: .infinity)
          }
          .accessibilityLabel("Learn \(chord.rawValue) chord")
          .accessibilityAddTraits(.isButton)

          ListDivider()
        }
        Spacer()
      }
    }
  }
}

#Preview {
  BasePreview {
    ChordView(songInfo: SongInfo.curriculum.first!)
  }
}
