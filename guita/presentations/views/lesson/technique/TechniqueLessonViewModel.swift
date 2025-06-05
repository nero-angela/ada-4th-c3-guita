//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.
import SwiftUI

final class TechniqueLessonViewModel: BaseViewModel<TechniqueLessonViewState> {
  private let textToSpeechManager = TextToSpeechManager.shared
  private let voiceCommandManager = VoiceCommandManager.shared
  private var playTask: Task<Void, Error>? = nil

  init() {
    let steps: [TechniqueLessonStep] = [
      TechniqueLessonStep(
        step: 1,
        totalSteps: 7,
        description: "Introduction to guitar techniques and strumming",
        imageName: "",
        subSteps: [TechniqueLessonSubStep(ttsText: "Let's learn the strumming technique, which involves plucking the strings up and down with a pick or fingers.", audioFile: nil, delayAfter: nil, speechRate: nil)],
        featureDescription: "Say 'Next' to proceed to the next lesson, or 'Repeat' to hear it again."
      ),
      TechniqueLessonStep(
        step: 2,
        totalSteps: 7,
        description: "Explanation of the sound hole of the guitar",
        imageName: "",
        subSteps: [TechniqueLessonSubStep(ttsText: "Look for the hole in the body of the guitar. This hole is called the sound hole.", audioFile: nil, delayAfter: nil, speechRate: nil)],
        featureDescription: "Say 'Previous' to go back, 'Next' to continue, or 'Repeat' to hear it again."
      ),
      TechniqueLessonStep(
        step: 3,
        totalSteps: 7,
        description: "Explanation of the up strum technique",
        imageName: "",
        subSteps: [TechniqueLessonSubStep(ttsText: "Place your right hand over the sound hole and sweep the strings from bottom to up.", audioFile: .stroke_up, delayAfter: nil, speechRate: nil),
                   TechniqueLessonSubStep(ttsText: "This is called an up strum. Try playing up strums freely.", audioFile: nil, delayAfter: nil, speechRate: nil)],
        featureDescription: "Say 'Previous' to go back, 'Next' to continue, or 'Repeat' to hear it again."
      ),
      TechniqueLessonStep(
        step: 4,
        totalSteps: 7,
        description: "Explanation of the down strum technique",
        imageName: "",
        subSteps: [TechniqueLessonSubStep(ttsText: "Place your right hand over the sound hole and sweep the strings from top to bottom.", audioFile: .stroke_down, delayAfter: nil, speechRate: nil),
                   TechniqueLessonSubStep(ttsText: "This is called a down strum. Try playing down strums freely.", audioFile: nil, delayAfter: nil, speechRate: nil)],
        featureDescription: "Say 'Previous' to go back, 'Next' to continue, or 'Repeat' to hear it again."
      ),
      TechniqueLessonStep(
        step: 5,
        totalSteps: 7,
        description: "Explanation of the calypso rhythm technique",
        imageName: "audio-file",
        subSteps: [
          TechniqueLessonSubStep(ttsText: "Let me introduce the most commonly used calypso rhythm technique.", audioFile: nil, delayAfter: nil, speechRate: nil),
          TechniqueLessonSubStep(
            ttsText: "Down",
            audioFile: nil,
            delayAfter: TechniqueLessonViewModel.calcDelay(for: "Down", speechRate: 0.45),
            speechRate: 0.45
          ),
          // Down-Up (second beat, quickly)
          TechniqueLessonSubStep(
            ttsText: "Down-Up",
            audioFile: nil,
            delayAfter: TechniqueLessonViewModel.calcDelay(for: "Down-Up", speechRate: 0.65),
            speechRate: 0.65
          ),
          // Up (third beat, quickly)
          TechniqueLessonSubStep(
            ttsText: "Up",
            audioFile: nil,
            delayAfter: TechniqueLessonViewModel.calcDelay(for: "Up", speechRate: 0.75),
            speechRate: 0.75
          ),
          // Down-Up (fourth beat, quickly)
          TechniqueLessonSubStep(
            ttsText: "Down-Up",
            audioFile: nil,
            delayAfter: TechniqueLessonViewModel.calcDelay(for: "Down-Up", speechRate: 0.65),
            speechRate: 0.65
          ),
          TechniqueLessonSubStep(ttsText: "Repeat after me and get used to the rhythm.", audioFile: nil, delayAfter: nil, speechRate: nil),
        ],
        featureDescription: "Say 'Previous' to go back, 'Next' to continue, or 'Repeat' to hear it again."
      ),
      TechniqueLessonStep(
        step: 6,
        totalSteps: 7,
        description: "Explanation of the calypso technique on guitar",
        imageName: "audio-file",
        subSteps: [TechniqueLessonSubStep(ttsText: "When you perform the calypso technique on the guitar, ", audioFile: .stroke_calipso, delayAfter: nil, speechRate: nil),
                   TechniqueLessonSubStep(ttsText: "it sounds like this. Try playing the calypso technique repeatedly.", audioFile: nil, delayAfter: nil, speechRate: nil)],
        featureDescription: "Say 'Previous' to go back, 'Next' to continue, or 'Repeat' to hear it again."
      ),
      TechniqueLessonStep(
        step: 7,
        totalSteps: 7,
        description: "Technique lesson completed.",
        imageName: "",
        subSteps: [TechniqueLessonSubStep(ttsText: "Technique lesson completed.", audioFile: nil, delayAfter: nil, speechRate: nil)],
        featureDescription: "Say 'Previous' to go back, or 'Repeat' to hear it again."
      ),
    ]
    super.init(state: TechniqueLessonViewState(currentStepIndex: 0, steps: steps))
  }

  private func cancelPlayTask() {
    playTask?.cancel()
  }

  func startVoiceCommand() {
    voiceCommandManager.start(
      commands: [
        VoiceCommand(keyword: .play, handler: { self.play() }),
        VoiceCommand(keyword: .retry, handler: { self.play(isRetry: true) }),
        VoiceCommand(keyword: .next, handler: nextStep),
        VoiceCommand(keyword: .previous, handler: previousStep),
        VoiceCommand(keyword: .stop, handler: dispose),
      ]
    )
  }

  func stopVoiceCommand() {
    voiceCommandManager.stop()
    textToSpeechManager.stop()
  }

  func play(isRetry _: Bool = false) {
    cancelPlayTask()
    playTask = Task {
      do {
        try await Task.sleep(nanoseconds: 100_000_000)

        let currentStep = state.steps[state.currentStepIndex]
        let stepNumber = currentStep.step
        let totalSteps = currentStep.totalSteps

        await textToSpeechManager.speak("Step \(stepNumber.koOrd) of \(totalSteps.koCard) steps")

//        for subStep in currentStep.subSteps {
//          try Task.checkCancellation()
//          if let ttsText = subStep.ttsText {
//            await textToSpeechManager.speak(ttsText)
//          }
//          try Task.checkCancellation()
//          if let audioFile = subStep.audioFile {
//            await AudioPlayerManager.shared.start(audioFile: audioFile)
//          }
//        }
        for subStep in currentStep.subSteps {
          try Task.checkCancellation()
          if let ttsText = subStep.ttsText {
            if let rate = subStep.speechRate {
              await textToSpeechManager.speak(ttsText, rate: rate)
            } else {
              await textToSpeechManager.speak(ttsText)
            }
            if let delay = subStep.delayAfter {
              try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
          }
          try Task.checkCancellation()
          if let audioFile = subStep.audioFile {
            await AudioPlayerManager.shared.start(audioFile: audioFile)
          }
        }
//        if !isRetry {
//          await textToSpeechManager.speak(currentStep.featureDescription)
//        }
      } catch {
        textToSpeechManager.stop()
        AudioPlayerManager.shared.stop()
      }
    }
  }

  override func dispose() {
    cancelPlayTask()
    stopVoiceCommand()
    textToSpeechManager.stop()
  }

  func nextStep() {
    cancelPlayTask()
    guard state.currentStepIndex < state.steps.count - 1 else { return }

    let newIndex = state.currentStepIndex + 1
    emit(state.copy(currentStepIndex: newIndex))
    playStepChangeSound {
      self.play()
    }
  }

  func previousStep() {
    cancelPlayTask()
    guard state.currentStepIndex > 0 else { return }
    let newIndex = state.currentStepIndex - 1
    emit(state.copy(
      currentStepIndex: newIndex
    ))
    playStepChangeSound {
      self.play()
    }
  }

  private func playStepChangeSound(completion: (() -> Void)? = nil) {
    Task {
      await AudioPlayerManager.shared.start(audioFile: .next)
      try? await Task.sleep(nanoseconds: 200_000_000)
      completion?()
    }
  }

  func currentImage() -> Image? {
    guard let imageName = state.currentStep.imageName, !imageName.isEmpty
    else {
      return nil
    }
    return Image(imageName)
  }

  private static func calcDelay(for text: String, speechRate: Float, targetBeat: TimeInterval = 0.6) -> TimeInterval {
    let baseDuration = Double(text.count) * 0.065 / Double(speechRate)
    let delay = max(0.0, targetBeat - baseDuration)
    return delay
  }
}
