//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

extension Int {
  var koOrd: String {
    switch self {
    case 1:
      return "first"
    case 2:
      return "second"
    case 3:
      return "third"
    case 4:
      return "fourth"
    case 5:
      return "fifth"
    case 6:
      return "sixth"
    case 7:
      return "seventh"
    case 8:
      return "eighth"
    case 9:
      return "ninth"
    case 10:
      return "tenth"
    default:
      return "\(self)th"
    }
  }

  var koCard: String {
    switch self {
    case 1:
      return "one"
    case 2:
      return "two"
    case 3:
      return "three"
    case 4:
      return "four"
    case 5:
      return "five"
    case 6:
      return "six"
    case 7:
      return "seven"
    case 8:
      return "eight"
    case 9:
      return "nine"
    case 10:
      return "ten"
    default:
      return "\(self)"
    }
  }
}
