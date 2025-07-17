import SwiftUI
import Foundation

struct PostsView: View {
    @StateObject var viewModel = PostsViewModel()
    @ObservedObject var usersViewModel: UsersViewModel
    @State private var showComments = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("All Posts").font(.system(size: 22, weight: .bold, design: .monospaced))
            if let posts = viewModel.posts {
                ScrollView() {
                    LazyVStack {
                        ForEach(posts, id: \.id) { post in
                            PostView(posts: viewModel, users: usersViewModel, post: post, showComments: $showComments)
                        }
                    }
                    .padding(.horizontal)
                }
            } else if viewModel.isLoading {
                VStack {
                    ProgressView("Loading...")
                }.frame(maxHeight: .infinity)
            } else {
                VStack {
                    Spacer()
                }
            }
            
//            Button(action: {
//                viewModel.fetchPosts()
//            }) {
//                HStack {
//                    Image(systemName: "internaldrive.fill")
//                    Text("fetch posts").font(.system(size: 16, weight: .semibold, design: .monospaced))
//                }
//                .padding()
//                .background {
//                    RoundedRectangle(cornerRadius: 20)
//                        .fill(.ultraThinMaterial)
//                }
//            }
//            .disabled(viewModel.isLoading)
//            .opacity(viewModel.isLoading ? 0.5 : 1.0)
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            viewModel.fetchPosts()
        }
        .sheet(isPresented: $showComments) {
            //on dismiss
        } content: {
            VStack(spacing: 35) {
                Text("Comments")
                if let currentComments = viewModel.postComments {
                    ScrollView() {
                        VStack {
                            ForEach(currentComments, id: \.id) { comment in
                                CommentView(comment: comment)
                            }
                        }.padding()
                    }
                }
            }
            .padding(.top)
            .presentationDetents([.fraction(0.75)])
        }
    }
}

fileprivate struct PostView: View {
    @ObservedObject var posts: PostsViewModel
    @ObservedObject var users: UsersViewModel
    let post: Post
    
    @Binding var showComments: Bool
    
    var body: some View {
        HStack() {
            VStack(alignment: .leading, spacing: 20) {
                Text(users.getPostAuthorName(with: post.userId))
                Text(post.title)
                
                HStack {
                    Spacer()
                    PostButton(iconName: "newspaper.fill") {
                        //
                    }
                    PostButton(iconName: "ellipsis.message.fill") {
                        posts.getCommentsForPost(with: post.id)
                        showComments = true
                    }
                }

            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThickMaterial)
        .cornerRadius(20)
    }
    
    struct PostButton: View {
        let iconName: String
        let action: () -> ()
        
        var body: some View {
            HStack {
                Image(systemName: iconName)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundStyle(.blue)
            }
            .padding(8)
            .background(Color.secondary)
            .cornerRadius(10)
            .onTapGesture {
                action()
            }
        }
    }
}

fileprivate struct CommentView: View {
    let comment: Comment
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 35, height: 35)
                .foregroundStyle(.cyan)

            VStack(alignment: .leading, spacing: 10) {
                Text(comment.email).font(.system(size: 14, weight: .bold))
                Text(comment.body)
            }
        }
        .padding()
        .padding(.trailing, 40)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
    }
}

#Preview {
    //PostsView(viewModel: PostsViewModel())
    CommentView(comment: Comment(postId: 1, id: 1, name: "hello_mr.robot", email: "mr.robot@gmail.com", body: "hellkfrasdajsdbnafbsashiahfiasfasdasdasdasdaiend"))
}

