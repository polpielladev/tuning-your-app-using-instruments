//
//  ContentView.swift
//  Kirja
//
//  Created by Pol Piella Abadia on 27/2/25.
//

import SwiftUI

@Observable final class GlobalSettings {
    var shareAnalytics: Bool = false
}

enum KirjaTab {
    case home
    case profile
}

struct ContentView: View {
    @State var selectedTab = KirjaTab.home
    @State var settings = GlobalSettings()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house.fill", value: KirjaTab.home) {
                Home()
            }

            Tab("Profile", systemImage: "person.fill", value: KirjaTab.profile) {
                Profile()
            }
        }
    }
}

#Preview {
    ContentView()
}
