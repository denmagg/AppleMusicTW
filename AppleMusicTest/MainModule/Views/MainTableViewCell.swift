//
//  MainTableViewCell.swift
//  AppleMusicTest
//
//  Created by Денис Медведев on 13.01.2023.
//

import UIKit

final class MainTableViewCell: UITableViewCell {
    
    static let reuseId = "MainTableViewCell"
    
    //MARK: private properties
    
    private let title: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 22)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()

    private let subtitle: UILabel = {
        let phoneNumberLabel = UILabel()
        phoneNumberLabel.font = .systemFont(ofSize: 14)
        phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        return phoneNumberLabel
    }()

    private var albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let activityIndicatior = {
        let activityIndicatior = UIActivityIndicatorView(style: .large)
        activityIndicatior.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicatior
    }()

    private lazy var verticalStack: UIStackView = {
        let stack = UIStackView()
        [title, subtitle].forEach { stack.addArrangedSubview($0) }
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    //MARK: inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        setupSubviews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }
    
    //MARK: init helpers
    
    private func setupSubviews() {
        [verticalStack, albumImageView].forEach { subview in contentView.addSubview(subview) }
        albumImageView.addSubview(activityIndicatior)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            albumImageView.heightAnchor.constraint(equalToConstant: 100),
            albumImageView.widthAnchor.constraint(equalToConstant: 100),
            albumImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            albumImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            albumImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            activityIndicatior.centerXAnchor.constraint(equalTo: albumImageView.centerXAnchor),
            activityIndicatior.centerYAnchor.constraint(equalTo: albumImageView.centerYAnchor),

            verticalStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 20),
            verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
    
    //MARK: cell configure methods
    
    func configure(with data: Album) {
        title.text = data.title
        subtitle.text = data.subtitle
        activityIndicatior.startAnimating()
    }
    
    func loadImage(image: UIImage?) {
        albumImageView.image = image
        activityIndicatior.stopAnimating()
    }
    
}

