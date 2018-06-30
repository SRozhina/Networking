import Foundation

let sharedApiUrl = "https://jsonplaceholder.typicode.com"

func makeUrlRequest(_ string: String, with parameters: [String: String] = [:]) -> URLRequest? {
    let queryItems = parameters.map({ URLQueryItem(name: $0.key, value: $0.value) })
    
    var urlComponents = URLComponents(string: string)
    urlComponents?.queryItems = queryItems
    
    guard let url = urlComponents?.url else { return nil }
    return URLRequest(url: url)
}
