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

struct ContentView: View {
    @State var settings = GlobalSettings()
    
    var body: some View {
        Home()
    }
}

#Preview {
    ContentView()
}
