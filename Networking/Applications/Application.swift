import Foundation

class Application {
    private let networkingService: INetworkingService = MoyaNetworkingService()
    
    func task1() {
        networkingService.getAllUsers { users in
            print("#1 Get all users")
            print(users)
        }
    }
    
    func task2() {
        getPostWithUsersAndComments(withId: 5) { postInfo in
            print("#2 Get post number 5 with user and comments")
            print(postInfo ?? "No info")
        }
    }
    
    func task3() {
        getAllPostInfos { postInfos in
            print("#3 Get all posts with user and comments")
            print(postInfos)
        }
    }
    
    func task4() {
        let newUser = User(id: 2, name: "Steven", username: "Monkey")
        networkingService.changeUser(withId: 2, to: newUser) { user in
            print("#4 Update user")
            print(user)
        }
    }
    
    private func getPostWithUsersAndComments(withId postId: Int, completion: @escaping (PostInfo?) -> Void) {
        networkingService.getPost(withId: postId) { post in
            if let post = post {
                var postInfo = PostInfo(post: post)
                
                self.networkingService.getAllCommentsFor(postId: postId) { comments in
                    postInfo.comments = comments
                    
                    self.networkingService.getUserWith(userId: post.userId) { user in
                        if let user = user {
                            postInfo.user = user
                            completion(postInfo)
                        }
                    }
                }
            }
        }
    }
    
    private func getAllPostInfos(completion: @escaping ([PostInfo]) -> Void) {
        networkingService.getAllPosts { posts in
            if posts.isEmpty { return }
            
            self.networkingService.getAllComments(completion: { comments in
                let commentsById = Dictionary(grouping: comments, by: { $0.postId })
                
                self.networkingService.getAllUsers(completion: { users in
                    let usersById = Dictionary(grouping: users, by: { $0.id })
                    
                    let postInfos: [PostInfo] = posts.map { post in
                        let postComments = commentsById[post.id] ?? []
                        let user = usersById[post.userId]?.first
                        return PostInfo(post: post, user: user, comments: postComments)
                    }
                    completion(postInfos)
                })
            })
        }
    }
}
