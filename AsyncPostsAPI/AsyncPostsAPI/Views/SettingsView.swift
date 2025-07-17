import SwiftUI

struct SettingsView: View {
    @State private var toggleOn = false
    var body: some View {
        VStack {
            Toggle(isOn: $toggleOn) {
                Text("Load data manually")
            }
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}
