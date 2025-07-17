import Foundation

@MainActor
class UsersViewModel: ObservableObject {
    
    @Published var users: [User]?
    @Published var isLoading = false
    
    func fetchUsers() {
        users = nil
        isLoading = true
        
        Task {
            let result = try await NetworkService().fetch([User].self, from: NetworkURLs.users)
            self.users = result.shuffled()
            self.isLoading = false
        }
    }
    
    func getInitials(from username: String) -> String {
        return String(username.prefix(2))
    }
    
    func getPostAuthorName(with postId: Int) -> String {
        guard let users = users else { return "" }
        if let index = users.firstIndex(where: {$0.id == postId}) {
            return users[index].username
        } else {
            return ""
        }
    }
}

