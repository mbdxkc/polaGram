//
//  HeaderViews.swift
//  polaGram
//
//  App header and logo views.
//  Extracted from ContentView.swift for maintainability.
//

import SwiftUI

// MARK: - Header

/// App header with logo and tagline.
struct PolaHeader: View {
    var body: some View {
        VStack(spacing: -12) {
            PolaLogo().drawingGroup()

            Text(PolaStrings.appTagline)
                .font(.polaBody(size: PolaLayout.subtitleSize))
                .kerning(1.5)
                .foregroundStyle(
                    LinearGradient(colors: [.polaSilverLight, .polaSilverDark], startPoint: .leading, endPoint: .trailing)
                )
                .shadow(color: .black.opacity(0.3), radius: 0, x: 0, y: -0.5)
                .shadow(color: .white.opacity(0.1), radius: 0, x: 0, y: 0.5)
                .shadow(color: .black.opacity(0.2), radius: 0.5, x: 0, y: 0.5)
                .offset(y: -4)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(PolaStrings.appTitle), \(PolaStrings.appTagline)")
    }
}

// MARK: - Logo

/// Stylized "polaGram" logo with gradient text.
struct PolaLogo: View {
    var body: some View {
        HStack(spacing: 0) {
            Text("pola")
                .font(.custom("MarkerFelt-Wide", size: PolaLayout.titleSize))
                .kerning(-1)
                .foregroundStyle(
                    LinearGradient(colors: [.polaSilverDark, .polaPinkLight], startPoint: .bottom, endPoint: .top)
                )
                .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 1)
            Text("Gram")
                .font(.custom("MarkerFelt-Wide", size: PolaLayout.titleSize))
                .kerning(-1)
                .foregroundStyle(
                    LinearGradient(colors: [.polaPinkLight, .polaPinkHot], startPoint: .top, endPoint: .bottom)
                )
                .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 1)
        }
        .shadow(color: .polaPinkLight.opacity(0.3), radius: 10, x: 0, y: 0)
    }
}
