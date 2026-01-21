//
//  DBZTabBarViewController.swift
//  CollectionViewEx
//
//  Created by Roderick Presswood on 3/13/24.
//

import UIKit

class DBZTabBarViewController: UITabBarController {
    
    let firstTab: DBZCharactersCollectionViewController = {
       let characterVC = DBZCharactersCollectionViewController()
        let personAvatar = UIImage(systemName: "person.fill")?.withTintColor(.black)
        let selectedPersonAvatar = UIImage(systemName: "person.fill")?.withTintColor(.blue)
        let tabBarItem = UITabBarItem(title: "Characters", image: personAvatar, selectedImage: selectedPersonAvatar)
        characterVC.tabBarItem = tabBarItem
        return characterVC
    }()
    
    let secondTab: DBZWorldsCollectionViewController = {
       let worldVC = DBZWorldsCollectionViewController()
        let worldAvatar = UIImage(systemName: "globe.americas.fill")?.withTintColor(.black)
        let selectedWorldAvatar = UIImage(systemName: "globe.americas.fill")?.withTintColor(.blue)
        let tabBarItem = UITabBarItem(title: "Worlds", image: worldAvatar, selectedImage: selectedWorldAvatar)
        worldVC.tabBarItem = tabBarItem
        return worldVC
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewControllers = [firstTab, secondTab]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .white.withAlphaComponent(0.3)
    }

}


extension DBZTabBarViewController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // Intentionally no logging in production.
    }
}
