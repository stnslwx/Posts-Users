import Foundation

@MainActor
class PostsViewModel: ObservableObject {
    
    @Published var posts: [Post]?
    
    @Published var comments: [Comment]?
    @Published var postComments: [Comment]?
    
    @Published var isLoading = false
    
    func fetchPosts() {
        posts = nil
        comments = nil
        isLoading = true
        
        Task {
            let result = try await NetworkService().fetch([Post].self, from: NetworkURLs.posts)
            self.posts = result.shuffled()
            self.isLoading = false
        }
        
        Task {
            let result = try await NetworkService().fetch([Comment].self, from: NetworkURLs.comments)
            self.comments = result
        }
    }
    
    func getCommentsForPost(with postId: Int) {
        guard let comments = comments else { return }
        postComments = comments.filter {$0.postId == postId}
    }

}
