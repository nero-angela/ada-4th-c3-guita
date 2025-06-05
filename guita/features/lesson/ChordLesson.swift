//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import Foundation

final class ChordLesson: BaseLesson {
  private let audioPlayerManager = AudioPlayerManager.shared
  private let textToSpeechManager = TextToSpeechManager.shared
  private let functionText = "Please say Next to move on to the next lesson. Please say Repeat to listen again."
  private var isNoteClassificationEnabled: Bool = false
  private var isChordClassificationEnabled: Bool = false
  let chord: Chord
  let steps: [ChordLessonStep]
  var totalStep: Int { steps.count }
  private var coordIdx: Int = 0

  init(_ chord: Chord) {
    self.chord = chord

    var result: [ChordLessonStep] = []

    // Add intro
    result.append(.introduction)

    // Add lineFingering & lineSoundCheck
    for coordIdx in chord.coordinates.indices {
      let coordinate = chord.coordinates[coordIdx]
      let nFret = coordinate.0.first!.fret
      let nString = coordinate.0.first!.string
      let nFinger = coordinate.1
      result.append(.lineFingering(nString: nString, nFret: nFret, nFinger: nFinger, coordIdx: coordIdx))
      result.append(.lineSoundCheck(nString: nString, nFret: nFret, nFinger: nFinger, coordIdx: coordIdx))
    }

    // Add chord fingering
    result.append(.chordFingering)

    // Add chord sound check
    result.append(.chordSoundCheck)

    // Add finish
    result.append(.finish)
    steps = result
  }

  override func onLessonCancel(_: any Error) {
    audioPlayerManager.stop()
    textToSpeechManager.stop()
  }

  /// 현재 단계
  private func currentStep(_ isReplay: Bool, _ index: Int) -> String {
    return isReplay ? "" : "Step \((index + 1).koOrd) of \(totalStep.koCard) steps"
  }

  /// Replay에서 읽지 않는 텍스트
  private func doNotReplayText(_ isReplay: Bool, _ text: String) -> String {
    return isReplay ? "" : text
  }

  /// 개요
  func startIntroduction(_ isReplay: Bool) async {
    isNoteClassificationEnabled = false
    isChordClassificationEnabled = false

    await startLesson([
      // MARK: 단계
      {
        let text = self.currentStep(isReplay, 0)
        await self.textToSpeechManager.speak(text)
      },

      // MARK: 설명
      {
        let plets = self.chord.frets.map { $0.koOrd }
        let nFingers = self.chord.nFingers
        let text = "\(self.chord) chord uses \(plets) flats and \(nFingers) fingers."
        await self.textToSpeechManager.speak(text)
      },
//      // MARK: 기능
//      {
//        let text = self.doNotReplayText(isReplay, self.functionText)
//        await self.textToSpeechManager.speak(text)
//      },
    ])
  }

  /// 한 줄씩 운지법 설명
  func startLineFingering(_ isReplay: Bool, index: Int, nString: Int, nFret: Int, nFinger: Int, coordIdx _: Int) async {
    isNoteClassificationEnabled = false
    isChordClassificationEnabled = false
    let (fret, string, finger) = (nFret.koOrd, nString.koOrd, nFinger.koOrd)
    await startLesson([
      // MARK: 단계
      {
        let text = self.currentStep(isReplay, index)
        await self.textToSpeechManager.speak(text)
      },

      // MARK: 개요
      {
        let text = self.doNotReplayText(isReplay, "Let’s play the \(self.chord) chord one string at a time")
        await self.textToSpeechManager.speak(text)
      },

      // MARK: 운지법 설명
      {
        let text = "With your \(finger) finger, press the \(string) string at the \(fret) fret."
        await self.textToSpeechManager.speak(text)
      },
    ])
  }

  /// 한 줄씩 사운드 체크
  func startLineSoundCheck(_ isReplay: Bool, index: Int, nString: Int, nFret: Int, nFinger: Int, coordIdx: Int) async {
    isNoteClassificationEnabled = false
    isChordClassificationEnabled = false
    let (fret, string, finger) = (nFret.koOrd, nString.koOrd, nFinger.koOrd)
    await startLesson([
      // MARK: 단계
      {
        let text = self.currentStep(isReplay, index)
        await self.textToSpeechManager.speak(text)
      },

      // MARK: 개요
      {
        let text = self.doNotReplayText(isReplay, "Let’s check the sound of the \(self.chord) chord.")
        await self.textToSpeechManager.speak(text)
      },

      // MARK: 운지법 설명
      {
        let text = "If you pluck the \(string) string, it should sound like this."
        await self.textToSpeechManager.speak(text)
      },

      // MARK: 재생 - 한 줄 소리
      {
        let audioKey = "\(self.chord.rawValue)_\(nString).wav"
        if let audioFile = AudioFile(rawValue: audioKey) {
          await self.audioPlayerManager.start(audioFile: audioFile)
        } else {
          Logger.e("Invalid audio file name: \(audioKey)")
        }
      },

      // MARK: 설명
      {
        let text = "Shall we pluck the \(string) string?"
        await self.textToSpeechManager.speak(text)
        self.coordIdx = coordIdx
        self.isNoteClassificationEnabled = true
      },
    ])
  }

  /// 코드 운지법 확인
  func startChordFingering(_ isReplay: Bool, index: Int) async {
    isNoteClassificationEnabled = false
    isChordClassificationEnabled = false

    await startLesson([
      // MARK: 단계
      {
        let text = self.currentStep(isReplay, index)
        await self.textToSpeechManager.speak(text)
      },

      // MARK: 개요
      {
        let text = self.doNotReplayText(isReplay, "Let’s grab an \(self.chord) chord.")
        await self.textToSpeechManager.speak(text)
      },

      // MARK: 설명
      {
        var text = ""
        for i in 0 ..< self.chord.coordinates.count {
          let isLast = i == self.chord.coordinates.count - 1
          let coordinate = self.chord.coordinates[i]
          let nFret = coordinate.0.first!.fret
          let nString = coordinate.0.first!.string
          let nFinger = coordinate.finger
          let (fret, string, finger) = (nFret.koOrd, nString.koOrd, nFinger.koOrd)
          text += "With your \(finger) finger, press the \(string) string at the \(fret) fret. "
        }
        await self.textToSpeechManager.speak(text)
      },
    ])
  }

  /// 코드 소리 확인
  func startChordSoundCheck(_ isReplay: Bool, index: Int) async {
    isNoteClassificationEnabled = false
    isChordClassificationEnabled = false

    await startLesson([
      // MARK: 단계
      {
        let text = self.currentStep(isReplay, index)
        await self.textToSpeechManager.speak(text)
      },

      // MARK: 개요
      {
        let text = self.doNotReplayText(isReplay, "Let’s check the sound of the \(self.chord) chord.")
        await self.textToSpeechManager.speak(text)
      },

      // MARK: 설명
      {
        let text = "The \(self.chord) chord should sound like this"
        await self.textToSpeechManager.speak(text)
      },

      // MARK: 재생 - 한 줄 소리
      {
        let audioKey = "\(self.chord.rawValue)_stroke_down.wav"
        if let audioFile = AudioFile(rawValue: audioKey) {
          await self.audioPlayerManager.start(audioFile: audioFile)
        } else {
          Logger.e("Invalid audio file name: \(audioKey)")
        }
      },

      // MARK: 설명
      {
        let text = "Now, try strumming down with your pick."
        await self.textToSpeechManager.speak(text)
        self.isChordClassificationEnabled = true
      },
    ])
  }

  /// 종료
  func startFinish(_: Bool, nextChord: Chord?) async {
    isNoteClassificationEnabled = false
    isChordClassificationEnabled = false
    await startLesson([
      // MARK: 단계
      {
        var text = "The \(self.chord) chord lesson has been completed."
        if nextChord != nil {
          // 다음 chord 학습
          text += " If you want to learn the \(nextChord!) chord next, please say “Next.”"
        } else {
          // 화면 종료
          text += " If you say “Next,” you will return to the previous “Chord Selection” screen."
        }
        await self.textToSpeechManager.speak(text)
      },
    ])
  }

  /// Chord 분류
  func onChordClassified(userChord: Chord?) {
    if !isChordClassificationEnabled { return }
    guard let userChord = userChord else { return }
    // Logger.d("Chord : \(chord), User Chord : \(userChord)")
    if chord == userChord {
      Task {
        await self.audioPlayerManager.start(audioFile: .answer)
      }
    }
  }

  /// Note 분류
  func onNoteClassified(userNote: Note?) {
    if !isNoteClassificationEnabled { return }
    guard let userNote = userNote else { return }
    guard coordIdx >= 0 && coordIdx < chord.notes.count else { return }
    let note = chord.notes[coordIdx]
    Logger.d("Note : \(note), User Note : \(userNote)")
    if note == userNote {
      Task {
        await self.audioPlayerManager.start(audioFile: .answer)
      }
    }
  }
}
