import SwiftUI

struct ContentView: View {
    @StateObject var usersViewModel = UsersViewModel()
    @State private var selectedTab: NavigationBarTab = .users
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .users:
                    UsersView(viewModel: usersViewModel)
                case .posts:
                    PostsView(usersViewModel: usersViewModel)
                case .setting:
                    SettingsView()
                }
            }.padding(.bottom, 80)

            NavigationBar(selected: $selectedTab)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
}
