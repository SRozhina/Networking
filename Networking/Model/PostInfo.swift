struct PostInfo {
    let post: Post
    var user: User?
    var comments: [Comment]
    
    init(post: Post, user: User? = nil, comments: [Comment] = []) {
        self.post = post
        self.user = user
        self.comments = comments
    }
}
