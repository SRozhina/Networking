protocol INetworkingService {
    func getAllUsers(completion: @escaping ([User]) -> Void)
    func getPost(withId id: Int, completion: @escaping (Post?) -> Void)
    func getAllCommentsFor(postId: Int, completion: @escaping ([Comment]) -> Void)
    func getUserWith(userId: Int, completion: @escaping (User?) -> Void)
    func changeUser(withId id: Int, to user: User, completion: @escaping (User) -> Void)
    func getAllPosts(completion: @escaping ([Post]) -> Void)
    func getAllComments(completion: @escaping ([Comment]) -> Void)
}
