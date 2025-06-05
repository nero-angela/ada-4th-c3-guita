//  Copyright © 2025 ADA 4th Challenge3 Team1. All rights reserved.

import SwiftUI

struct HomeView: View {
  @EnvironmentObject var router: Router

  var body: some View {
    BaseView(
      create: { HomeViewModel() }
    ) { _, _ in
      VStack {
        // MARK: Toolbar
        Toolbar(title: "Guita", accessibilityText: "Guita, the guitar you play with your ears, has begun. To start learning, please press the ‘Start Learning Guitar’ button", isPopButton: false, trailing: {
          // MARK: Dev Button
          Text("Dev")
            .opacity(0.01)
            .onLongPressGesture {
              router.push(.dev)
            }.accessibilityHidden(true)
        })
        Spacer()
        Button {
          router.push(.curriculum)
        } label: {
          VStack {
            Image("pick")
              .resizable()
              .frame(width: 47, height: 54)
              .padding(.bottom, 43)
            Text("Start Learning Guitar")
              .fontKoddi(32, color: .light, weight: .bold)
          }.offset(y: -80)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      }
    }
  }
}

#Preview {
  BasePreview {
    HomeView()
  }
}
