//
//  NetworkManager.swift
//  NetworkAndCollectionView
//
//  Created by Михаил Малышев on 16.03.2022.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {} 
    
    func getRandomImages(completion: @escaping (Data?, Error?) -> Void) {
        let parameters = setupRandomParameters()
        let url = randomUrl(parameters: parameters)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = setupHeader()
        request.httpMethod = "GET"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    func fetchRandomImages(completion: @escaping ([Image]?) -> Void) {
        getRandomImages { (data, error) in
            guard let data = data else { return }

            let decoder = JSONDecoder()
            do {
                let images = try decoder.decode([Image].self, from: data)
                completion(images)
            } catch let error {
                print(error)
            }
        }
    }
    
    // MARK: - Supporting private functions
    
    private func setupHeader() -> [String: String]? {
        var headers = [String: String]()
        let accessKey = "uRSr80j9iOQLO8Y17Kmuwbp_eGFLJtTKVcqkhyHylNs"
        headers["Authorization"] = "Client-ID \(accessKey)"
        return headers
    }
    
    private func setupRandomParameters() -> [String: String] {
        var parameters = [String: String]()
        parameters["count"] = String(30)
        return parameters
    }
    
    private func randomUrl(parameters: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/photos/random"
        components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}
