//
//  DBZDetailView.swift
//  CollectionViewEx
//
//  Created by Roderick Presswood on 3/13/24.
//

import UIKit

enum DetailType {
    case character
    case world
}

class DBZDetailView: UIView {
    
    var titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var descrptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var kiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var maxKiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var raceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var genderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var affiliationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var isDestroyedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setup(with item: Item? = nil, worldItem: Worlds? = nil, detailType: DetailType) {
        addSubview(titleImageView)
        addSubview(scrollView)
        
        scrollView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(nameLabel)
        mainStackView.addArrangedSubview(descrptionLabel)
        
        
        
        
        switch detailType {
        case .character:
            guard let item else {
                return
            }
            mainStackView.addArrangedSubview(kiLabel)
            mainStackView.addArrangedSubview(maxKiLabel)
            mainStackView.addArrangedSubview(raceLabel)
            mainStackView.addArrangedSubview(genderLabel)
            mainStackView.addArrangedSubview(affiliationLabel)
            downloadImage(from: item.image)
            nameLabel.text = "Character Name: \(item.name)"
            descrptionLabel.text = "Character Info: \(item.description)"
            kiLabel.text = "Base Ki: \(item.ki)"
            maxKiLabel.text = "Max Ki: \(item.maxKi)"
            raceLabel.text = "Race: \(item.race)"
            genderLabel.text = "Sex: \(item.gender)"
            affiliationLabel.text = "Affiliation \(item.affiliation)"
        case .world:
            guard let worldItem else {
                return
            }
            mainStackView.addArrangedSubview(isDestroyedLabel)
            downloadImage(from: worldItem.image)
            nameLabel.text = "World Name: \(worldItem.name)"
            descrptionLabel.text = "Character Info: \(worldItem.description)"
            isDestroyedLabel.text = "Planet Status: \(worldItem.isDestroyed ? "Existing" :"Destroyed")"
        }
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        translatesAutoresizingMaskIntoConstraints = false
        let contentGuide = scrollView.contentLayoutGuide
        let frameGuide = scrollView.frameLayoutGuide
        
        NSLayoutConstraint.activate([
            titleImageView.heightAnchor.constraint(equalToConstant: 300),
            titleImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            titleImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            titleImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            
            scrollView.topAnchor.constraint(equalTo: titleImageView.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: contentGuide.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: frameGuide.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: frameGuide.trailingAnchor, constant: -20)
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
                    self.titleImageView.image = image
                }
            }
        }.resume()
    }
}
