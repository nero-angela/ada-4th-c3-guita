//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

enum VoiceCommandKeyword: CaseIterable {
  case start
  case stop
  case play
  case retry
  case next
  case previous
  case fast
  case slow

  var phrases: [String] {
    switch self {
    case .start: ["start"]
    case .stop: ["stop"]
    case .play: ["play"]
    case .retry: ["retry", "again", "replay"]
    case .next: ["next"]
    case .previous: ["previous"]
    case .fast: ["fast"]
    case .slow: ["slow"]
    }
  }
}
