//
//  DBZViewModel.swift
//  CollectionViewEx
//
//  Created by Roderick Presswood on 3/7/24.
//

import Foundation
import UIKit

class DBZCharactersViewModel {
    
    var dbzCharacters = DBZModel(items: [Item]())
    var image = UIImage()
    
    let network: NetworkManager
    
    
    init(network: NetworkManager = NetworkManager()) {
        self.network = network
    }
    
    func getDBZCharacters(onUpdate: (@MainActor () -> Void)? = nil) {
        guard let url = URL(string: ApiEndpoints.characterURL) else {
            // need to id error
            return
        }
        network.fetchData(url: url, modelType: DBZModel.self, completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let characters):
                self.dbzCharacters = characters
                if let onUpdate {
                    Task { @MainActor in
                        onUpdate()
                    }
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func getDBZCharacterImages(from item: Item) -> UIImage {
        network.downloadImage(from: item.image) { result in
            switch result {
            case .success(let success):
                self.image = success
                print("ok")
            case .failure(let failure):
                print("yes")
            }
        }
        return image
    }
    
    func getDBZCharacterImage(from item: Item) {
        guard let url = URL(string: item.image) else {
            return
        }
        network.downloadImage(from: url) { image, error in
            if let error = error {
                //                    continuation.resume(throwing: <#T##Never#>)
                return
            }
            guard let image = image else {
                //                    continuation.resume(throwing: <#T##Never#>)
                return
            }
            //                continuation.resume(returning:/* image)*/
            self.image = image
        }
    }
    
    
    func getCharacterCount() -> Int {
        dbzCharacters.items.count
    }
    
    
}
