//
//  DBZWorldsCollectionViewController.swift
//  CollectionViewEx
//
//  Created by Roderick Presswood on 3/13/24.
//

import UIKit

class DBZWorldsCollectionViewController: UICollectionViewController {

    let viewModel = DBZWorldsViewModel()
    
    let backgroundImage: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "Space")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 125, height: 125)
        layout.scrollDirection = .vertical
        super.init(collectionViewLayout: layout)
        collectionView.frame = .zero
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       Task {
           await self.viewModel.getDBZWorlds()
        }
        
        setupCollectionView()
        
        self.view.addSubview(backgroundImage)
        self.view.sendSubviewToBack(backgroundImage)
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    private func setupCollectionView() {
        self.collectionView.frame = .zero
        self.collectionView.backgroundColor = .clear
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView!.register(DBZReusableCollectionViewCell.self, forCellWithReuseIdentifier: DBZReusableCollectionViewCell.identifier)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getWorldsCount()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DBZReusableCollectionViewCell.identifier, for: indexPath) as! DBZReusableCollectionViewCell
        let item = viewModel.dbzWorlds.items[indexPath.row]
        cell.configure(with: item.image, name: item.name)
        cell.nameLabel.textColor = .white
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        let newVC = DBZDetailViewController(worlds: viewModel.dbzWorlds.items[indexPath.row], type: .world)
        showDetailViewController(newVC, sender: self)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
            cell?.backgroundColor = UIColor.gray
    }
    
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
            cell?.backgroundColor = UIColor.clear
    }
}
