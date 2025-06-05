//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct TechniqueLessonView: View {
  @EnvironmentObject var router: Router

  var body: some View {
    PermissionView {
      BaseView(
        create: { TechniqueLessonViewModel() }
      ) { viewModel, state in
        VStack {
          // MARK: Toolbar
          Toolbar(title: "Technique Lesson", accessibilityText: "This is the screen for learning techniques. Press the play button to start learning.", trailing: {
            IconButton("info", color: .light, isSystemImage: false) {
              router.push(.techniqueLessonGuide)
            }.accessibilityAddTraits(.isButton)
              .accessibilityLabel("Usage Guide")

          })

          Spacer()

          // MARK: Step/TotalStep
          Text("\(state.currentStep.step)/\(state.currentStep.totalSteps) Steps")
            .fontKoddi(22, color: .darkGrey, weight: .regular)
            .accessibilityHidden(true)

          // MARK: description
          VStack {
            if let image = viewModel.currentImage() {
              image
                .resizable()
                .scaledToFit()
                .frame(width: 87, height: 95)
            }

            Text(state.currentStep.description)
              .fontKoddi(26, color: .light, weight: .bold)
              .padding(.horizontal, 30)
              .multilineTextAlignment(.center)
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .accessibilityHidden(true)

          // MARK: Button(back/play/next)
          HStack {
            let isFirstStep = (state.currentStepIndex == 0)
            Button(action: {
              if !isFirstStep {
                viewModel.previousStep()
              }
            }) {
              Image("chevron-left")
                .resizable()
                .frame(width: 75, height: 75)
                .padding(.trailing, 42)
            }
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel(isFirstStep ? "Previous (Disabled)" : "Previous")
            .opacity(isFirstStep ? 0.5 : 1.0)
            .accessibilityAddTraits([.isButton, .startsMediaSession])

            Button(action: { viewModel.play() }) {
              Image("play")
                .resizable()
                .frame(width: 95, height: 95)
            }.accessibilityAddTraits(.isButton)
              .accessibilityLabel("Play")
              .accessibilityAddTraits([.isButton, .startsMediaSession])

            Button(action: {
              viewModel.nextStep()
            }) {
              Image("chevron-right")
                .resizable()
                .frame(width: 75, height: 75)
                .padding(.leading, 42)
            }
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel("Next")
            .accessibilityAddTraits([.isButton, .startsMediaSession])
          }
        }.padding(.bottom, 5)
          .onAppear {
            viewModel.startVoiceCommand()
          }
          .onDisappear {
            viewModel.dispose()
          }
      }
    }
  }
}

#Preview {
  BasePreview {
    TechniqueLessonView()
  }
}
