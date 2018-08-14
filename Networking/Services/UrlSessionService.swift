import Foundation

class UrlSessionService: INetworkingService {
    func getAllPosts(completion: @escaping ([Post]) -> Void) {
        let postUrl = sharedApiUrl + "/posts"
        guard let urlRequest = makeUrlRequest(postUrl) else { return }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if error != nil { return }
            guard let responseData = data else { return }
            let decoder = JSONDecoder()
            guard let posts = try? decoder.decode([Post].self, from: responseData) else {
                fatalError("Could not parse JSON")
            }
            completion(posts)
        }
        task.resume()
    }
    
    func getAllComments(completion: @escaping ([Comment]) -> Void) {
        let commentsUrl = sharedApiUrl + "/comments"
        guard let urlRequest = makeUrlRequest(commentsUrl) else { return }

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if error != nil { return }
            guard let responseData = data else { return }
            let decoder = JSONDecoder()
            guard let comments = try? decoder.decode([Comment].self, from: responseData) else {
                fatalError("Could not parse JSON")
            }
            completion(comments)
        }
        task.resume()
    }
    
    func getAllUsers(completion: @escaping ([User]) -> Void) {
        let usersUrl = sharedApiUrl + "/users"
        guard let urlRequest = makeUrlRequest(usersUrl) else { return }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if error != nil { return }
            guard let responseData = data else { return }
            
            let decoder = JSONDecoder()
            guard let users = try? decoder.decode([User].self, from: responseData) else {
                fatalError("Could not parse JSON")
            }
            completion(users)
        }
        task.resume()
    }
    
    func getPost(withId id: Int, completion: @escaping (Post?) -> Void) {
        let postUrl = sharedApiUrl + "/posts/\(id)"
        guard let postUrlRequest = makeUrlRequest(postUrl) else { return }
        
        let postTask = URLSession.shared.dataTask(with: postUrlRequest) { data, response, error in
            if error != nil { return }
            guard let responseData = data else { return }
            let decoder = JSONDecoder()
            guard let post = try? decoder.decode(Post.self, from: responseData) else {
                fatalError("Could not parse JSON")
            }
            completion(post)
        }
        postTask.resume()
    }
    
    func getAllCommentsFor(postId: Int, completion: @escaping ([Comment]) -> Void) {
        let commentsUrl = sharedApiUrl + "/comments"
        let parameters = ["postId": "\(postId)"]
        guard let commentsUrlRequest = makeUrlRequest(commentsUrl, with: parameters) else { return }
        let commentsTask = URLSession.shared.dataTask(with: commentsUrlRequest) { data, response, error in
            if error != nil { return }
            guard let responseData = data else { return }
            let decoder = JSONDecoder()
            guard let comments = try? decoder.decode([Comment].self, from: responseData) else {
                fatalError("Could not parse JSON")
            }
            completion(comments)
        }
        commentsTask.resume()
    }
    
    func getUserWith(userId: Int, completion: @escaping (User?) -> Void) {
        let userUrl = sharedApiUrl + "/users/\(userId)"
        guard let userUrlRequest = makeUrlRequest(userUrl) else { return }
        
        let userTask = URLSession.shared.dataTask(with: userUrlRequest) { data, response, error in
            if error != nil { return }
            guard let responseData = data else { return }
            let decoder = JSONDecoder()
            guard let user = try? decoder.decode(User.self, from: responseData) else {
                fatalError("Could not parse JSON")
            }
            completion(user)
        }
        userTask.resume()
    }
    
    func changeUser(withId id: Int, to user: User, completion: @escaping (User) -> Void) {
        let userUrl = sharedApiUrl + "/users/\(id)"
        
        guard var userUrlRequest = makeUrlRequest(userUrl) else { return }
        userUrlRequest.httpMethod = "PATCH"
        
        guard let newUserBody = try? JSONEncoder().encode(user) else { return }
        userUrlRequest.httpBody = newUserBody
        
        let userTask = URLSession.shared.dataTask(with: userUrlRequest) { data, response, error in
            if error != nil { return }
            guard let responseData = data else { return }
            
            let decoder = JSONDecoder()
            guard let user = try? decoder.decode(User.self, from: responseData) else {
                fatalError("Could not parse JSON")
            }
            
            completion(user)
        }
        userTask.resume()
    }
}
