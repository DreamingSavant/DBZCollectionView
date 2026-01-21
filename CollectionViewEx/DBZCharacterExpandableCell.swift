//
//  DBZCharacterExpandableCell.swift
//  CollectionViewEx
//
//  Created by Roderick Presswood on 1/21/26.
//

import UIKit

final class DBZCharacterExpandableCell: UICollectionViewCell {
    
    // MARK: - Static Properties
    
    static let identifier = String(describing: DBZCharacterExpandableCell.self)
    
    // MARK: - Properties
    
    private var currentImageURL: URL?
    private var currentItem: Item?
    var onViewMoreTapped: ((Item) -> Void)?
    var isExpanded: Bool = false {
        didSet {
            updateExpandedState(animated: true)
        }
    }
    
    // MARK: - UI Components
    
    private let cardContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.15, alpha: 0.95)
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 12
        view.layer.shadowOpacity = 0.3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let expandIndicator: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .systemOrange
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let raceTagView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.8)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let raceTagLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let detailView: DBZCharacterInlineDetailView = {
        let view = DBZCharacterInlineDetailView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        view.isHidden = true
        return view
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        view.isHidden = true
        return view
    }()
    
    // MARK: - Constraints
    
    private var detailViewHeightConstraint: NSLayoutConstraint?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        currentImageURL = nil
        currentItem = nil
        characterImageView.image = nil
        nameLabel.text = nil
        raceTagLabel.text = nil
        isExpanded = false
        detailView.alpha = 0
        detailView.isHidden = true
        separatorView.alpha = 0
        separatorView.isHidden = true
        expandIndicator.transform = .identity
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(cardContainerView)
        cardContainerView.addSubview(headerContainerView)
        cardContainerView.addSubview(separatorView)
        cardContainerView.addSubview(detailView)
        
        headerContainerView.addSubview(characterImageView)
        headerContainerView.addSubview(nameLabel)
        headerContainerView.addSubview(expandIndicator)
        headerContainerView.addSubview(raceTagView)
        raceTagView.addSubview(raceTagLabel)
        
        detailView.onViewMoreTapped = { [weak self] in
            guard let item = self?.currentItem else { return }
            self?.onViewMoreTapped?(item)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        let detailHeightConstraint = detailView.heightAnchor.constraint(equalToConstant: 0)
        detailViewHeightConstraint = detailHeightConstraint
        
        NSLayoutConstraint.activate([
            cardContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            cardContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            cardContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            headerContainerView.topAnchor.constraint(equalTo: cardContainerView.topAnchor),
            headerContainerView.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor),
            headerContainerView.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor),
            headerContainerView.heightAnchor.constraint(equalToConstant: 180),
            
            characterImageView.topAnchor.constraint(equalTo: headerContainerView.topAnchor, constant: 12),
            characterImageView.centerXAnchor.constraint(equalTo: headerContainerView.centerXAnchor),
            characterImageView.widthAnchor.constraint(equalToConstant: 100),
            characterImageView.heightAnchor.constraint(equalToConstant: 100),
            
            raceTagView.topAnchor.constraint(equalTo: headerContainerView.topAnchor, constant: 8),
            raceTagView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor, constant: -8),
            raceTagView.heightAnchor.constraint(equalToConstant: 20),
            
            raceTagLabel.topAnchor.constraint(equalTo: raceTagView.topAnchor, constant: 2),
            raceTagLabel.bottomAnchor.constraint(equalTo: raceTagView.bottomAnchor, constant: -2),
            raceTagLabel.leadingAnchor.constraint(equalTo: raceTagView.leadingAnchor, constant: 8),
            raceTagLabel.trailingAnchor.constraint(equalTo: raceTagView.trailingAnchor, constant: -8),
            
            nameLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor, constant: -12),
            
            expandIndicator.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            expandIndicator.centerXAnchor.constraint(equalTo: headerContainerView.centerXAnchor),
            expandIndicator.widthAnchor.constraint(equalToConstant: 20),
            expandIndicator.heightAnchor.constraint(equalToConstant: 12),
            
            separatorView.topAnchor.constraint(equalTo: headerContainerView.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            detailView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            detailView.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor),
            detailView.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with item: Item, isExpanded: Bool) {
        currentItem = item
        nameLabel.text = item.name
        raceTagLabel.text = item.race.uppercased()
        downloadImage(from: item.image)
        detailView.configure(with: item)
        self.isExpanded = isExpanded
        updateExpandedState(animated: false)
    }
    
    // MARK: - State Updates
    
    private func updateExpandedState(animated: Bool) {
        let changes = {
            self.detailView.isHidden = !self.isExpanded
            self.separatorView.isHidden = !self.isExpanded
            self.detailView.alpha = self.isExpanded ? 1 : 0
            self.separatorView.alpha = self.isExpanded ? 1 : 0
            self.expandIndicator.transform = self.isExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
        }
        
        if animated {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
                changes()
            }
        } else {
            changes()
        }
    }
    
    // MARK: - Image Loading
    
    private func downloadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        currentImageURL = url
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            guard url == self.currentImageURL else { return }
            guard let data = data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                guard url == self.currentImageURL else { return }
                self.characterImageView.image = image
            }
        }.resume()
    }
}
