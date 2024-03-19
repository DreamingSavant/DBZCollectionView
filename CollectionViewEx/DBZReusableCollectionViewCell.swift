//
//  DBZCollectionViewCell.swift
//  CollectionViewEx
//
//  Created by Roderick Presswood on 3/7/24.
//

import UIKit
enum type {
    case Character
    case World
}

class DBZReusableCollectionViewCell: UICollectionViewCell {
    
    static let identifier = DBZReusableCollectionViewCell.description()
    
    let dbzImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        // may need to add width, height constraints
        return imageView
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has been implemented")
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dbzImageView.image = nil
        nameLabel.text = ""
    }
    
    func configure(with imageURL: String, name: String) {
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(dbzImageView)
        stackView.addArrangedSubview(nameLabel)
        
        downloadImage(from: imageURL)
        nameLabel.text = name
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    func downloadImage(from url: String) {
        guard let url = URL(string: url) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let data = data, let image = UIImage(data: data), url == url {
                DispatchQueue.main.async {
                    self.dbzImageView.image = image
                }
            }
        }.resume()
    }
}
