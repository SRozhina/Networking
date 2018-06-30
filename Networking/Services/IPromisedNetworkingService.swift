import Promises

protocol IPromisedNetworkingService {
    func getAllUsers() -> Promise<[User]>
    func getPost(withId id: Int) -> Promise<Post>
    func getAllCommentsFor(postId: Int) -> Promise<[Comment]>
    func getUserWith(userId: Int) -> Promise<User>
    func changeUser(withId id: Int, to user: User) -> Promise<User>
    func getAllPosts() -> Promise<[Post]>
    func getAllComments() -> Promise<[Comment]>
}
