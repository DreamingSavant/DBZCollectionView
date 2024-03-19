//
//  DBZModel.swift
//  CollectionViewEx
//
//  Created by Roderick Presswood on 3/7/24.
//

import Foundation

struct DBZModel: Decodable {
    var items: [Item]
}

struct Item: Decodable {
    var id: Int
    var name: String
    var ki: String
    var maxKi: String
    var race: String
    var gender: String
    var description: String
    var image: String
    var affiliation: String
}
