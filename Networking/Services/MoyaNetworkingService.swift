import Foundation
import Moya
import Result

fileprivate enum MoyaTestAPI {
    case posts
    case postWith(id: Int)
    case comments
    case commentFor(postId: Int)
    case users
    case userWith(id: Int)
    case updateUser(id: Int, updatedUser: User)
}

extension MoyaTestAPI: TargetType {
    var path: String {
        switch self {
        case .posts:
            return "posts/"
        case .postWith(let id):
            return "posts/\(id)"
        case .comments:
            return "/comments/"
        case .commentFor(let postId):
            return "comments/\(postId)"
        case .users:
            return "users/"
        case .userWith(let id):
            return "users/\(id)"
        case .updateUser(let id, _):
            return "users/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .updateUser(_, _):
            return .patch
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .updateUser(_, let updatedUser):
            return .requestJSONEncodable(updatedUser)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var baseURL: URL {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/") else { fatalError("Base url is not configured") }
        return url
    }
}

class MoyaNetworkingService: INetworkingService {
    private typealias MoyaResponse = (Result<Moya.Response, MoyaError>)
    
    private let provider = MoyaProvider<MoyaTestAPI>()
    
    func getAllUsers(completion: @escaping ([User]) -> Void) {
        provider.request(.users) { moyaResult in
            let users = self.getResult(from: moyaResult) as [User]?
            completion(users ?? [])
        }
    }
    
    func getPost(withId id: Int, completion: @escaping (Post?) -> Void) {
        provider.request(.postWith(id: id)) { moyaResult in
            let post = self.getResult(from: moyaResult) as Post?
            completion(post)
        }
    }
    
    func getAllCommentsFor(postId: Int, completion: @escaping ([Comment]) -> Void) {
        provider.request(.comments) { moyaResult in
            let comments = self.getResult(from: moyaResult) as [Comment]?
            completion(comments ?? [])
        }
    }
    
    func getUserWith(userId: Int, completion: @escaping (User?) -> Void) {
        provider.request(.userWith(id: userId)) { moyaResult in
            let user = self.getResult(from: moyaResult) as User?
            completion(user)
        }
    }
    
    func changeUser(withId id: Int, to user: User, completion: @escaping (User) -> Void) {
        provider.request(.updateUser(id: id, updatedUser: user)) { moyaResult in
            let user = self.getResult(from: moyaResult) as User?
            completion(user!)
        }
    }
    
    func getAllPosts(completion: @escaping ([Post]) -> Void) {
        provider.request(.posts) { moyaResult in
            let posts = self.getResult(from: moyaResult) as [Post]?
            completion(posts ?? [])
        }
    }
    
    func getAllComments(completion: @escaping ([Comment]) -> Void) {
        provider.request(.comments) { moyaResult in
            let comments = self.getResult(from: moyaResult) as [Comment]?
            completion(comments ?? [])
        }
    }
    
    private func getResult<T: Decodable>(from response: MoyaResponse) -> T? {
        switch response {
        case .success(let response):
            let result: T? = try? response.data.decoded()
            return result
        case .failure(let error):
            print(error)
            return nil
        }
    }
}
