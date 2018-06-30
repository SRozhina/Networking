import Foundation
import Promises

class ApplicationPromised {
    private let networkingService: IPromisedNetworkingService = PromisedUrlSessionService()
    
    func task1() {
        networkingService.getAllUsers().then { users in
            print("#1 Get all users")
            print(users)
        }
    }
    
    func task2() {
        getPostWithUsersAndComments(withId: 5).then { postInfo in
            print("#2 Get post number 5 with user and comments")
            print(postInfo)
        }
    }
    
    func task3() {
        getAllPostInfos().then { postInfos in
            print("#3 Get all postsre with user and comments")
            print(postInfos)
        }
        
    }
    
    func task4() {
        let newUser = User(id: 2, name: "Steven", username: "Monkey")
        networkingService.changeUser(withId: 2, to: newUser).then { user in
            print("#4 Update user")
            print(user)
        }
    }
    
    private func getPostWithUsersAndComments(withId postId: Int) -> Promise<PostInfo> {
        let postAndCommentsPromise = all(networkingService.getPost(withId: postId),
                                         networkingService.getAllCommentsFor(postId: postId))
        return postAndCommentsPromise.then { post, comments in
            return self.networkingService.getUserWith(userId: post.userId).then { user in
                let postInfo = PostInfo(post: post, user: user, comments: comments)
                return Promise(postInfo)
            }
        }
    }
    
    private func getAllPostInfos() -> Promise<[PostInfo]> {
        return all(networkingService.getAllPosts(),
                   networkingService.getAllComments(),
                   networkingService.getAllUsers())
            .then { posts, comments, users in
                if posts.isEmpty { return Promise([]) }
                let commentsById = Dictionary(grouping: comments, by: { $0.postId })
                let usersById = Dictionary(grouping: users, by: { $0.id })
                let postInfos: [PostInfo] = posts.map { post in
                    let postComments = commentsById[post.id] ?? []
                    let user = usersById[post.userId]?.first
                    return PostInfo(post: post, user: user, comments: postComments)
                }
                return Promise(postInfos)
        }
    }
    
    private func promiseDemo() {
        // bad - promise hell == callback hell
        networkingService.getAllUsers().then { users in
            print(users)
            
            self.networkingService.getAllComments().then { comments in
                print(comments)
                
                self.networkingService.getAllPosts().then { posts in
                    print(posts)
                }
            }
        }
        
        // Good - fix for promise hell
        networkingService.getAllUsers()
            .then { users -> Promise<[Comment]> in
                print(users)
                return self.networkingService.getAllComments()
            }
            .then { comments -> Promise<[Post]> in
                print(comments)
                return self.networkingService.getAllPosts()
            }
            .then { posts in
                print(posts)
        }
        
        // Good 2.0 - fix for promise hell
        let getComments: ([User]) -> Promise<[Comment]> = { users  in
            print(users)
            return self.networkingService.getAllComments()
        }
        
        let getPosts: ([Comment]) -> Promise<[Post]> = { comments  in
            print(comments)
            return self.networkingService.getAllPosts()
        }
        
        let handlePosts: ([Post]) -> Void = { posts in
            print(posts)
        }
        
        networkingService.getAllUsers()
            .then (getComments)
            .then (getPosts)
            .then (handlePosts)
    }
}
