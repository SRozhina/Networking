import Foundation
import Promises

enum NetworkError: Error {
    case fail
}

class PromisedUrlSessionService: IPromisedNetworkingService {
    
    func getAllPosts() -> Promise<[Post]> {
        let postsUrl = sharedApiUrl + "/posts"
        guard let urlRequest = makeUrlRequest(postsUrl) else { return Promise(NetworkError.fail) }
        
        return URLSession.shared.dataTaskPromised(with: urlRequest).then { data in
            let decoder = JSONDecoder()
            guard let posts = try? decoder.decode([Post].self, from: data) else {
                fatalError("Could not parse JSON")
            }
            return Promise(posts)
        }
    }
    
    func getAllComments() -> Promise<[Comment]> {
        let commentsUrl = sharedApiUrl + "/comments"
        guard let urlRequest = makeUrlRequest(commentsUrl) else { return Promise(NetworkError.fail) }
        
        return URLSession.shared.dataTaskPromised(with: urlRequest).then { data in
            let decoder = JSONDecoder()
            guard let comments = try? decoder.decode([Comment].self, from: data) else {
                fatalError("Could not parse JSON")
            }
            return Promise(comments)
        }
    }
    
    func getAllUsers() -> Promise<[User]> {
        let usersUrl = sharedApiUrl + "/users"
        guard let urlRequest = makeUrlRequest(usersUrl) else { return Promise(NetworkError.fail) }
        
        return URLSession.shared.dataTaskPromised(with: urlRequest).then { data in
            let decoder = JSONDecoder()
            guard let users = try? decoder.decode([User].self, from: data) else {
                fatalError("Could not parse JSON")
            }
            return Promise(users)
        }
    }
    
    func getPost(withId id: Int) -> Promise<Post> {
        let postUrl = sharedApiUrl + "/posts/\(id)"
        guard let postUrlRequest = makeUrlRequest(postUrl) else { return Promise(NetworkError.fail) }
        
        return URLSession.shared.dataTaskPromised(with: postUrlRequest).then { data in
            let decoder = JSONDecoder()
            guard let post = try? decoder.decode(Post.self, from: data) else {
                fatalError("Could not parse JSON")
            }
            return Promise(post)
        }
    }
    
    func getAllCommentsFor(postId: Int) -> Promise<[Comment]> {
        let commentsUrl = sharedApiUrl + "/comments"
        let parameters = ["postId": "\(postId)"]
        guard let commentsUrlRequest = makeUrlRequest(commentsUrl, with: parameters) else { return Promise(NetworkError.fail) }
        
        return URLSession.shared.dataTaskPromised(with: commentsUrlRequest).then { data in
            let decoder = JSONDecoder()
            guard let comments = try? decoder.decode([Comment].self, from: data) else {
                fatalError("Could not parse JSON")
            }
            return Promise(comments)
        }
    }
    
    func getUserWith(userId: Int) -> Promise<User> {
        let userUrl = sharedApiUrl + "/users/\(userId)"
        guard let userUrlRequest = makeUrlRequest(userUrl) else { return Promise(NetworkError.fail) }
        
        return URLSession.shared.dataTaskPromised(with: userUrlRequest).then { data in
            let decoder = JSONDecoder()
            guard let user = try? decoder.decode(User.self, from: data) else {
                fatalError("Could not parse JSON")
            }
            return Promise(user)
        }
    }
    
    func changeUser(withId id: Int, to user: User) -> Promise<User> {
        let userUrl = sharedApiUrl + "/users/\(id)"
        
        guard var userUrlRequest = makeUrlRequest(userUrl) else { return Promise(NetworkError.fail) }
        userUrlRequest.httpMethod = "PATCH"
        
        guard let newUser = try? JSONEncoder().encode(user) else { return Promise(NetworkError.fail) }
        userUrlRequest.httpBody = newUser
        
        return URLSession.shared.dataTaskPromised(with: userUrlRequest).then { data in
            let decoder = JSONDecoder()
            guard let user = try? decoder.decode(User.self, from: data) else {
                fatalError("Could not parse JSON")
            }
            return Promise(user)
        }
    }
}

extension URLSession {
    func dataTaskPromised(with urlRequest: URLRequest) -> Promise<Data> {
        return Promise<Data> { fulfill, reject in
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    reject(error)
                    return
                }
                guard let responseData = data else {
                    let defaultError = NetworkError.fail
                    reject(defaultError)
                    return
                }
                fulfill(responseData)
            }
            task.resume()
        }
    }
}
