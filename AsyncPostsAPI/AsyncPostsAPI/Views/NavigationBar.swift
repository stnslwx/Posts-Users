import SwiftUI
import Foundation

enum NavigationBarTab: CaseIterable {
    case users
    case posts
    case setting
}

extension NavigationBarTab {
    var iconName: String {
        switch self {
        case .users:
            return "person"
        case .posts:
            return "newspaper"
        case .setting:
            return "gearshape"
        }
    }
}

struct NavigationBar: View {
    @Binding var selected: NavigationBarTab
    
    var body: some View {
        HStack() {
            ForEach(NavigationBarTab.allCases, id: \.self) { tab in
                Image(systemName: selected != tab ? tab.iconName : tab.iconName + ".fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .onTapGesture {
                        selected = tab
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.blue)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .background(.thickMaterial)
    }
}

#Preview {
    NavigationBar(selected: .constant(.posts))
}
