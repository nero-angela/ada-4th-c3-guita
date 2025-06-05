//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct ChordLessonView: View {
  @EnvironmentObject var router: Router
  let chord: Chord
  let chords: [Chord]

  var body: some View {
    BaseView(
      create: { ChordLessonViewModel(router, chord, chords) }
    ) { viewModel, state in
      PermissionView(
        permissionListener: { isGranted in
          if isGranted {
            viewModel.onPermissionGranted()
          }
        }
      ) {
        VStack(spacing: 0) {
          // MARK: Toolbar
          Toolbar(title: "\(state.chord.rawValue) Chord", accessibilityText: "This screen is for learning the \(state.chord.rawValue) chord. To start the lesson, please say play.", trailing: {
            IconButton("info") {
              router.push(.chordLessonGuide)
            }.accessibilityAddTraits(.isButton)
              .accessibilityLabel("Help Guide")
          })

          // MARK: Index
          Text("\(state.index + 1)/\(state.totalStep) steps")
            .fontKoddi(22, color: .darkGrey)
            .padding(.top, 16)
            .accessibilityHidden(true)
          Spacer()

          // MARK: Step description
          Text(state.description)
            .fontKoddi(26, color: .light)
            .lineSpacing(1.45)
            .multilineTextAlignment(.center)
            .accessibilityHidden(true)

          Spacer()

          // MARK: Controllers
          HStack {
            IconButton("chevron-left", color: .light, size: 95, disabled: state.step == .introduction) {
              viewModel.goPrevious()
            }.accessibilityAddTraits(.isButton)
              .accessibilityLabel(state.step == .introduction ? "Previous (disabled)" : "Previous")
              .accessibilityAddTraits([.isButton, .startsMediaSession])

            IconButton("play", color: .accent, size: 95) {
              viewModel.play()
            }.accessibilityAddTraits(.isButton)
              .accessibilityLabel("Play \(state.description)")
              .accessibilityAddTraits([.isButton, .startsMediaSession])

            IconButton("chevron-right", size: 95) {
              viewModel.goNext()
            }.accessibilityAddTraits(.isButton)
              .accessibilityLabel(viewModel.nextChordAccessibilityLabel) // Assuming this is already localized; no change needed if dynamic
              .accessibilityAddTraits([.isButton, .startsMediaSession])
          }
        }
      }
    }
  }
}

#Preview {
  BasePreview {
    ChordLessonView(chord: .A, chords: [.A, .E, .B7])
  }
}
