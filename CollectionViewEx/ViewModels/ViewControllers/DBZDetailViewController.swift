//
//  DBZDetailViewController.swift
//  CollectionViewEx
//
//  Created by Roderick Presswood on 3/13/24.
//

import UIKit

class DBZDetailViewController: UIViewController {
    
    let item: Item?
    let worlds: Worlds?
    let type: DetailType
    
    let detailView = DBZDetailView()
    
    let backgroundImage: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "SteelBackground")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(item: Item? = nil, worlds: Worlds? = nil, type: DetailType) {
        self.item = item
        self.worlds = worlds
        self.type = type
        self.detailView.setup(with: item, worldItem: worlds, detailType: type)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        // Do any additional setup after loading the view.
    }
    
    
    func setupConstraints() {
        view.addSubview(backgroundImage)
        view.addSubview(detailView)
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.topAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
