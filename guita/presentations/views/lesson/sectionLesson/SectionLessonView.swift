//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct SectionLessonView: View {
  @EnvironmentObject var router: Router

  var body: some View {
    BaseView(
      create: { SectionLessonViewModel(router) }
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
          Toolbar(title: "Section Lesson", accessibilityText: "Practice breaking a song into sections using calypso strumming. To start the lesson, please say play.", trailing: {
            IconButton("info", color: .light, isSystemImage: false) {
              router.push(.sectionLessonGuide)
            }.accessibilityAddTraits(.isButton)
              .accessibilityLabel("Help Guide")
          })
          Spacer()
            .aspectRatio(2.5, contentMode: .fit)

          // MARK: Index
          Text("\(state.currentStepIndex + 1)/\(state.steps.count) Step")
            .fontKoddi(22, color: .darkGrey)
            .padding(.top, 16)
            .accessibilityHidden(true)

          // MARK: Step description
          if let firstInfo = state.currentStep.sectionLessonInfo.first {
            ChordProgressionBar(chords: firstInfo.chords)
              .accessibilityHidden(true)
          }

          Spacer()
            .aspectRatio(1, contentMode: .fit)

          // MARK: Controllers
          HStack {
            IconButton("chevron-left", size: 95, disabled: state.currentStepIndex == 0) {
              viewModel.previousStep()
            }.accessibilityAddTraits(.isButton)
              .accessibilityLabel(state.currentStepIndex == 0 ? "Previous (Disabled)" : "Previous")
              .accessibilityAddTraits([.isButton, .startsMediaSession])

            IconButton("play", color: .accent, size: 95) {
              viewModel.play()
            }
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel("Play")
            .accessibilityAddTraits([.isButton, .startsMediaSession])

            IconButton("chevron-right", size: 95, disabled: state.currentStepIndex == state.steps.count - 1) {
              viewModel.nextStep()
            }
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel("Next")
            .accessibilityAddTraits([.isButton, .startsMediaSession])
          }
        }
      }
    }
  }
}

#Preview {
  BasePreview {
    SectionLessonView()
  }
}
