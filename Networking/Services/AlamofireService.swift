import Foundation
import Alamofire

class AlamofireService: INetworkingService {
    func getAllUsers(completion: @escaping ([User]) -> Void) {
        let getAllUsersEndpoint = sharedApiUrl + "/users"
        Alamofire.request(getAllUsersEndpoint).responseData { response in
            guard let responseData = response.result.value else { return }
            let decoder = JSONDecoder()
            guard let users = try? decoder.decode([User].self, from: responseData) else {
                fatalError("Could not parse JSON")
            }
            
            completion(users)
        }
    }
    
    func getPost(withId id: Int, completion: @escaping (Post?) -> Void) {
        let getPost = sharedApiUrl + "/posts/\(id)"
        Alamofire.request(getPost).responseData { response in
            guard let responseData = response.result.value else { return }
            let decoder = JSONDecoder()
            guard let post = try? decoder.decode(Post.self, from: responseData) else {
                fatalError("Could not parse JSON")
            }
            completion(post)
        }
    }
    
    func getAllCommentsFor(postId: Int, completion: @escaping ([Comment]) -> Void) {
        let getComments = sharedApiUrl + "/comments?postId=\(postId)"
        let parameters = ["postId": postId]
        Alamofire.request(getComments, parameters: parameters).responseData { response in
            guard let responseData = response.result.value else { return }
            let decoder = JSONDecoder()
            guard let comments = try? decoder.decode([Comment].self, from: responseData) else {
                fatalError("Could not parse JSON")
            }
            completion(comments)
        }
    }
    
    func getUserWith(userId: Int, completion: @escaping (User?) -> Void) {
        let getUser = sharedApiUrl + "/users/\(userId)"
        Alamofire.request(getUser).responseData { response in
            guard let responseData = response.result.value else { return }
            let decoder = JSONDecoder()
            guard let user = try? decoder.decode(User.self, from: responseData) else {
                fatalError("Could not parse JSON")
            }
            completion(user)
        }
    }
    
    func getAllPosts(completion: @escaping ([Post]) -> Void) {
        let getPosts = sharedApiUrl + "/posts"
        Alamofire.request(getPosts).responseData { response in
            guard let responseData = response.result.value else { return }
            let decoder = JSONDecoder()
            guard let posts = try? decoder.decode([Post].self, from: responseData) else {
                fatalError("Could not parse JSON")
            }
            completion(posts)
        }
    }
    
    func getAllComments(completion: @escaping ([Comment]) -> Void) {
        let getComments = sharedApiUrl + "/comments"
        Alamofire.request(getComments).responseData { response in
            guard let responseData = response.result.value else { return }
            let decoder = JSONDecoder()
            guard let comments = try? decoder.decode([Comment].self, from: responseData) else {
                fatalError("Could not parse JSON")
            }
            completion(comments)
        }
    }
    
    func changeUser(withId id: Int, to user: User, completion: @escaping (User) -> Void) {
        let getUser = sharedApiUrl + "/users/\(id)"
        let newUserData: [String: Any] = ["id": user.id,
                                          "name": user.name,
                                          "username": user.username]
        Alamofire.request(getUser, method: .patch, parameters: newUserData).responseData {response in
            guard let responseData = response.result.value else { return }
            
            let decoder = JSONDecoder()
            guard let user = try? decoder.decode(User.self, from: responseData) else {
                fatalError("Could not parse JSON")
            }
            
            completion(user)
        }
    }

}
