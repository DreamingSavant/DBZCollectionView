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

final class DBZReusableCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: DBZReusableCollectionViewCell.self)
    
    private var currentImageURL: URL?
    
    private let dbzImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        // may need to add width, height constraints
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        currentImageURL = nil
        dbzImageView.image = nil
        nameLabel.text = nil
    }
    
    func configure(with imageURL: String, name: String) {
        downloadImage(from: imageURL)
        nameLabel.text = name
    }
    
    private func setupUI() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(dbzImageView)
        stackView.addArrangedSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func downloadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        currentImageURL = url
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            guard url == self.currentImageURL else { return }
            guard let data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                guard url == self.currentImageURL else { return }
                self.dbzImageView.image = image
            }
        }.resume()
    }
}
