//
//  DBZCharacterInlineDetailView.swift
//  CollectionViewEx
//
//  Created by Roderick Presswood on 1/21/26.
//

import UIKit

class DBZCharacterInlineDetailView: UIView {
    
    // MARK: - UI Components
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let leftStatsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let rightStatsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let kiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.9)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let maxKiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.9)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let raceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.9)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.9)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let affiliationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.9)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let viewMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("View Full Details", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.8)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    
    var onViewMoreTapped: (() -> Void)?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .clear
        
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(descriptionLabel)
        containerStackView.addArrangedSubview(statsContainerView)
        containerStackView.addArrangedSubview(viewMoreButton)
        
        statsContainerView.addSubview(leftStatsStack)
        statsContainerView.addSubview(rightStatsStack)
        
        leftStatsStack.addArrangedSubview(createStatRow(icon: "bolt.fill", label: kiLabel))
        leftStatsStack.addArrangedSubview(createStatRow(icon: "bolt.circle.fill", label: maxKiLabel))
        leftStatsStack.addArrangedSubview(createStatRow(icon: "person.fill", label: raceLabel))
        
        rightStatsStack.addArrangedSubview(createStatRow(icon: "figure.stand", label: genderLabel))
        rightStatsStack.addArrangedSubview(createStatRow(icon: "flag.fill", label: affiliationLabel))
        
        viewMoreButton.addTarget(self, action: #selector(viewMoreButtonTapped), for: .touchUpInside)
        
        setupConstraints()
    }
    
    private func createStatRow(icon: String, label: UILabel) -> UIStackView {
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: icon)
        iconImageView.tintColor = .systemOrange
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [iconImageView, label])
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .center
        return stackView
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            
            leftStatsStack.topAnchor.constraint(equalTo: statsContainerView.topAnchor),
            leftStatsStack.leadingAnchor.constraint(equalTo: statsContainerView.leadingAnchor),
            leftStatsStack.bottomAnchor.constraint(lessThanOrEqualTo: statsContainerView.bottomAnchor),
            leftStatsStack.widthAnchor.constraint(equalTo: statsContainerView.widthAnchor, multiplier: 0.5, constant: -8),
            
            rightStatsStack.topAnchor.constraint(equalTo: statsContainerView.topAnchor),
            rightStatsStack.trailingAnchor.constraint(equalTo: statsContainerView.trailingAnchor),
            rightStatsStack.bottomAnchor.constraint(lessThanOrEqualTo: statsContainerView.bottomAnchor),
            rightStatsStack.widthAnchor.constraint(equalTo: statsContainerView.widthAnchor, multiplier: 0.5, constant: -8),
            
            statsContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            
            viewMoreButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with item: Item) {
        descriptionLabel.text = item.description
        kiLabel.text = item.ki
        maxKiLabel.text = item.maxKi
        raceLabel.text = item.race
        genderLabel.text = item.gender
        affiliationLabel.text = item.affiliation
    }
    
    // MARK: - Actions
    
    @objc private func viewMoreButtonTapped() {
        onViewMoreTapped?()
    }
}
