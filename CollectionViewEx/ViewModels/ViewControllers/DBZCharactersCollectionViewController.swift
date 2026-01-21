//
//  ViewController.swift
//  CollectionViewEx
//
//  Created by Roderick Presswood on 3/3/24.
//

import UIKit
import Combine
import NotificationCenter

class DBZCharactersCollectionViewController: UIViewController {
    
    let backgroundImage: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "CloudImage")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 125, height: 125)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(DBZReusableCollectionViewCell.self, forCellWithReuseIdentifier: DBZReusableCollectionViewCell.identifier)
        return collectionView
    }()
    
    var cancellables = Set<AnyCancellable>()
    var viewModel = DBZCharactersViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        setupConstraints()
        
        viewModel.getDBZCharacters { [weak self] in
            self?.collectionView.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) { 
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    func setupConstraints() {
        self.view.addSubview(backgroundImage)
        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        ])
    }

    
    func setupNotificationForCollectionView() {
//        NotificationCenter.default.publisher(for: UICollectionView.reloadDataNotification, object: collectionView)
//            .sink { _ in
//                print("CollectionView reloaded!")
//            }
//            .store(in: &cancellables)
    }

}

extension DBZCharactersCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getCharacterCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DBZReusableCollectionViewCell.identifier, for: indexPath) as! DBZReusableCollectionViewCell
        let item = viewModel.dbzCharacters.items[indexPath.row]
        cell.configure(with: item.image, name: item.name)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        let item = viewModel.dbzCharacters.items[indexPath.row]
        let newVC = DBZDetailViewController(item: item, type: .character)
        showDetailViewController(newVC, sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
            cell?.backgroundColor = UIColor.gray
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
            cell?.backgroundColor = UIColor.clear
    }
}
