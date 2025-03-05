import SwiftUI

struct Settings: View {
    @Binding var settings: GlobalSettings
    
    var body: some View {
        VStack {
            Toggle("Share analytics", isOn: $settings.shareAnalytics)
        }
    }
}
