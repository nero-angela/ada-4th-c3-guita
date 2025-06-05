//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

enum ChordLessonStep: Equatable {
  case introduction
  case lineFingering(nString: Int, nFret: Int, nFinger: Int, coordIdx: Int)
  case lineSoundCheck(nString: Int, nFret: Int, nFinger: Int, coordIdx: Int)
  case chordFingering
  case chordSoundCheck
  case finish

  static func == (lhs: ChordLessonStep, rhs: ChordLessonStep) -> Bool {
    switch (lhs, rhs) {
    case (.introduction, .introduction),
         (.lineFingering, .lineFingering),
         (.lineSoundCheck, .lineSoundCheck),
         (.chordFingering, .chordFingering),
         (.chordSoundCheck, .chordSoundCheck),
         (.finish, .finish):
      return true
    default:
      return false
    }
  }

  func getDescription(_ chord: Chord, index _: Int) -> String {
    switch self {
    case .introduction:
      return "\(chord.rawValue) Chord Overview"
    case let .lineFingering(nString, _, _, _):
      return "\(chord.rawValue) Chord Fingering Explanation for String \(nString.koOrd)"
    case let .lineSoundCheck(nString, _, _, _):
      return "\(chord.rawValue) Chord Sound Check for String \(nString.koOrd)"
    case .chordFingering:
      return "\(chord.rawValue) Chord Fingering Explanation"
    case .chordSoundCheck:
      return "\(chord.rawValue) Chord Sound Check"
    case .finish:
      return "\(chord.rawValue) Chord Lesson Complete"
    }
  }
}
