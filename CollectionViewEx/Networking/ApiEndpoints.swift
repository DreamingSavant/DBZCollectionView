//
//  ApiEndpoints.swift
//  CollectionViewEx
//
//  Created by Roderick Presswood on 3/7/24.
//

import Foundation

// MARK: - API Configuration

enum ApiEndpoints {
    
    // MARK: - Base Configuration
    
    private static let baseURL = "https://dragonball-api.com/api"
    
    // MARK: - Endpoints
    
    enum Characters {
        static let defaultLimit = 78
        static let defaultPage = 0
        
        static func list(page: Int = defaultPage, limit: Int = defaultLimit) -> String {
            "\(baseURL)/characters?page=\(page)&limit=\(limit)"
        }
        
        static func detail(id: Int) -> String {
            "\(baseURL)/characters/\(id)"
        }
    }
    
    enum Planets {
        static var list: String {
            "\(baseURL)/planets"
        }
        
        static func detail(id: Int) -> String {
            "\(baseURL)/planets/\(id)"
        }
    }
    
    // MARK: - Legacy Support (Backward Compatibility)
    
    static let characterURL = Characters.list()
    static let planetURL = Planets.list
}
