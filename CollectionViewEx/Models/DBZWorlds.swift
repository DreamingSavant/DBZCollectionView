//
//  DBZWorlds.swift
//  CollectionViewEx
//
//  Created by Roderick Presswood on 3/7/24.
//

import Foundation

struct DBZWorlds: Decodable {
    var items: [Worlds]
}

struct Worlds: Decodable {
    var id: Int
    var name: String
    var isDestroyed: Bool
    var description: String
    var image: String
}
