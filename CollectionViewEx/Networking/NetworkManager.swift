//
//  NetworkManager.swift
//  CollectionViewEx
//
//  Created by Roderick Presswood on 3/7/24.
//

import Foundation
import UIKit

// MARK: - Networking Error

enum NetworkingError: Error, LocalizedError {
    case urlError
    case serverError
    case dataError
    case parsingError
    case other
    
    var errorDescription: String? {
        switch self {
        case .urlError:
            return "Invalid URL"
        case .serverError:
            return "Server returned an error"
        case .dataError:
            return "No data received"
        case .parsingError:
            return "Failed to parse response"
        case .other:
            return "An unexpected error occurred"
        }
    }
}

// MARK: - Networking Protocol

protocol Networking {
    func getDataFromNetworkingLayer<T: Decodable>(url: URL, modelType: T.Type) async throws -> T
    func makeRequest(url: URL) -> URLRequest
    func fetchData<T: Decodable>(url: URL, modelType: T.Type, completion: @escaping ((Result<T, NetworkingError>) -> Void))
}

// MARK: - Image Cache

final class ImageCache {
    static let shared = ImageCache()
    
    private let cache = NSCache<NSURL, UIImage>()
    
    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024 // 50 MB
    }
    
    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }
    
    func setImage(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}

// MARK: - Network Manager

final class NetworkManager: Networking {
    
    // MARK: - Properties
    
    private let session: URLSession
    private let decoder: JSONDecoder
    private let imageCache: ImageCache
    
    // MARK: - Configuration
    
    private enum Configuration {
        static let timeoutInterval: TimeInterval = 15.0
        static let httpMethod = "GET"
    }
    
    // MARK: - Initialization
    
    init(session: URLSession = .shared, imageCache: ImageCache = .shared) {
        self.session = session
        self.imageCache = imageCache
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    // MARK: - Request Building
    
    func makeRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.timeoutInterval = Configuration.timeoutInterval
        request.httpMethod = Configuration.httpMethod
        return request
    }
    
    // MARK: - Data Fetching (Completion-based)
    
    func fetchData<T: Decodable>(
        url: URL,
        modelType: T.Type,
        completion: @escaping ((Result<T, NetworkingError>) -> Void)
    ) {
        let request = makeRequest(url: url)
        
        session.dataTask(with: request) { [weak self] data, response, error in
            guard let self else { return }
            
            if error != nil {
                completion(.failure(.urlError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.serverError))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.serverError))
                return
            }
            
            guard let data else {
                completion(.failure(.dataError))
                return
            }
            
            do {
                let parsedObject = try self.decoder.decode(modelType, from: data)
                completion(.success(parsedObject))
            } catch {
                completion(.failure(.parsingError))
            }
        }
        .resume()
    }
    
    // MARK: - Data Fetching (Async/Await)
    
    func getDataFromNetworkingLayer<T: Decodable>(
        url: URL,
        modelType: T.Type
    ) async throws -> T {
        let request = makeRequest(url: url)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkingError.serverError
        }
        
        do {
            return try decoder.decode(modelType, from: data)
        } catch {
            throw NetworkingError.parsingError
        }
    }
    
    // MARK: - Image Downloading (Result-based)
    
    func downloadImage(
        from urlString: String,
        completion: @escaping ((Result<UIImage, NetworkingError>) -> Void)
    ) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }
        
        // Check cache first
        if let cachedImage = imageCache.image(for: url) {
            DispatchQueue.main.async {
                completion(.success(cachedImage))
            }
            return
        }
        
        session.dataTask(with: url) { [weak self] data, response, error in
            guard error == nil else {
                completion(.failure(.dataError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.serverError))
                return
            }
            
            guard let data, let image = UIImage(data: data) else {
                completion(.failure(.other))
                return
            }
            
            // Cache the image
            self?.imageCache.setImage(image, for: url)
            
            DispatchQueue.main.async {
                completion(.success(image))
            }
        }
        .resume()
    }
    
    // MARK: - Image Downloading (Tuple-based)
    
    func downloadImage(
        from url: URL,
        completion: @escaping (UIImage?, NetworkingError?) -> Void
    ) {
        // Check cache first
        if let cachedImage = imageCache.image(for: url) {
            DispatchQueue.main.async {
                completion(cachedImage, nil)
            }
            return
        }
        
        session.dataTask(with: url) { [weak self] data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(nil, .urlError)
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(nil, .serverError)
                }
                return
            }
            
            guard let data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil, .dataError)
                }
                return
            }
            
            // Cache the image
            self?.imageCache.setImage(image, for: url)
            
            DispatchQueue.main.async {
                completion(image, nil)
            }
        }
        .resume()
    }
}
