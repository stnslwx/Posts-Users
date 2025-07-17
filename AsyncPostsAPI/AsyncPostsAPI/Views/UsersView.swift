import SwiftUI

struct UsersView: View {
    @ObservedObject var viewModel: UsersViewModel
    
    let columns: [GridItem] = Array(repeating: GridItem(.flexible(), alignment: .top), count: 3)
    
    var body: some View {
        VStack {
            if let users = viewModel.users {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(users, id: \.id) { user in
                            VStack {
                                Text(viewModel.getInitials(from: user.username))
                                    .padding()
                                    .textCase(.uppercase)
                                    .background {
                                        Circle().fill(.cyan)
                                    }
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundStyle(.white)

                                Text(user.username)
                                    .font(.system(size: 14))
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
            } else if viewModel.isLoading {
                ProgressView("Loading...")
            }
            
        }
        .frame(maxHeight: .infinity)
        .onAppear {
            viewModel.fetchUsers()
        }
    }
}
