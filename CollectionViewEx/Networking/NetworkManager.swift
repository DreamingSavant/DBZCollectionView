//
//  NetworkManager.swift
//  CollectionViewEx
//
//  Created by Roderick Presswood on 3/7/24.
//

import Foundation
import UIKit

protocol Networking {
    func getDataFromNetworkingLayer<T: Decodable>(url: URL, modelType: T.Type) async throws -> T
    func makeRequest(url: URL) -> URLRequest
    func fetchData<T: Decodable>(url: URL, modelType: T.Type, completion: @escaping ((Result<T, NetworkingError>) -> Void))
}


enum NetworkingError: Error {
    case urlError
    case serverError
    case dataError
    case parsingError
    case other
}


class NetworkManager: Networking {
    func makeRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.timeoutInterval = 15.0
        request.httpMethod = "GET"
        return request
    }
    
    func fetchData<T>(url: URL, modelType: T.Type, completion: @escaping ((Result<T, NetworkingError>) -> Void)) where T : Decodable {
        let session = URLSession(configuration: .default)
        let request  = makeRequest(url: url)
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(NetworkingError.urlError))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkingError.dataError))
                return
            }
            
            let decoder = JSONDecoder()
            
            guard let parsedObject = try? decoder.decode(modelType, from: data) else {
                completion(.failure(NetworkingError.parsingError))
                return
            }
            
            completion(.success(parsedObject))
        }
        .resume()
    }
    
    func getDataFromNetworkingLayer<T>(url: URL, modelType: T.Type) async throws -> T where T : Decodable {
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let parsedData = try decoder.decode(modelType, from: data)
        return parsedData
    }
    
    func downloadImage(from urlString: String, completion: @escaping ((Result<UIImage, NetworkingError>) -> Void)) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkingError.urlError))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(NetworkingError.dataError))
                return
            }
            
            guard let image = UIImage(data: data) else {
                completion(.failure(NetworkingError.other))
                return
            }
            DispatchQueue.main.async {
                completion(.success(image))
            }
        }
        task.resume()
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?, NetworkingError?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, NetworkingError.serverError)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil, NetworkingError.dataError)
                return
            }
            completion(image, nil)
        }
        .resume()
    }
}
