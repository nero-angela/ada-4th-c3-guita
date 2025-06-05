//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

enum RootPage {
  case splash
  case home
  var title: String {
    switch self {
    case .home:
      return "귀타 시작"
    case .splash:
      return "스플래쉬"
    }
  }
}

enum SubPage: Hashable {
  case curriculum
  case lesson(songInfo: SongInfo)
  case chord(songInfo: SongInfo)
  case chordLesson(chord: Chord, chords: [Chord])
  case chordLessonGuide
  case techniqueLesson
  case techniqueLessonGuide
  case sectionLesson
  case sectionLessonGuide
  case fullLesson(songInfo: SongInfo)
  case fullLessonGuide

  // MARK: Dev
  case dev
  case devNoteClassification
  case devCodeClassification
  case devVoiceCommand
  case devConfig
  case devPermission
  case devTextToSpeech
}

struct RouterViewState {
  let rootPage: RootPage
  let subPages: [SubPage]

  func copy(
    rootPage: RootPage? = nil,
    subPages: [SubPage]? = nil
  ) -> RouterViewState {
    return RouterViewState(
      rootPage: rootPage ?? self.rootPage,
      subPages: subPages ?? self.subPages
    )
  }
}

extension SubPage {
  var title: String {
    switch self {
    case .curriculum:
      return "Curriculum"
    case let .lesson(songInfo):
      return "\(songInfo.level)"
    case .chord:
      return "Chord Learning"
    case let .chordLesson(songInfo):
      return "\(songInfo.chord) Chord"
    case .chordLessonGuide:
      return "Chord Learning Guide"
    case .techniqueLesson:
      return "Technique Learning"
    case .techniqueLessonGuide:
      return "Technique Learning Guide"
    case .sectionLesson:
      return "Section Learning"
    case .sectionLessonGuide:
      return "Section Learning Guide"
    case let .fullLesson(songInfo):
      return "\(songInfo.title) Full Song Learning"
    case .fullLessonGuide:
      return "Full Song Learning Guide"
    case .dev:
      return "Development"
    case .devNoteClassification:
      return "Note Classification"
    case .devCodeClassification:
      return "Chord Classification"
    case .devVoiceCommand:
      return "Voice Command"
    case .devConfig:
      return "Configuration"
    case .devPermission:
      return "Permissions"
    case .devTextToSpeech:
      return "TTS"
    }
  }
}
