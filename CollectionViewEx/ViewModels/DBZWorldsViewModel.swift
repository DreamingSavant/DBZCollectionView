//
//  DBZWorldsViewModel.swift
//  CollectionViewEx
//
//  Created by Roderick Presswood on 3/13/24.
//

import Foundation

class DBZWorldsViewModel {
    
    var dbzWorlds = DBZWorlds(items: [Worlds]())
    
    let network: NetworkManager
    
    init(network: NetworkManager = NetworkManager()) {
        self.network = network
    }
    
    @MainActor
    func getDBZWorlds() async {
        
        guard let url = URL(string: ApiEndpoints.planetURL) else {
            // need to id error
            return
        }
        do {
            let worlds = try await network.getDataFromNetworkingLayer(url: url, modelType: DBZWorlds.self)
            self.dbzWorlds = worlds
            #if DEBUG
            print(self.dbzWorlds)
            #endif
        } catch {
            
            #if DEBUG
            print(error.localizedDescription)
            #endif
        }
    }
    
    func getWorldsCount() -> Int {
        dbzWorlds.items.count
    }
}
