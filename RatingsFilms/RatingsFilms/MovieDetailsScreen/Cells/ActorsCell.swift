// ActorsCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

final class ActorsCell: UICollectionViewCell {
    // MARK: Constants

    private enum Constants {
        static let startUrlText = "https://image.tmdb.org/t/p/w300"
    }

    // MARK: Visual Components

    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .red
        return imageView
    }()

    private let nameActorLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoImageView)
        setPhotoImageViewConstraints()
        addSubview(nameActorLabel)
        setNameActorLabelConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private Function

    func setCollectionCell(actors: Actor) {
        nameActorLabel.text = actors.name
        guard let imageName = actors.actorImage else { return }
        let urlString = Constants.startUrlText + imageName
        printContent(urlString)
        guard let imageUrl = URL(string: urlString) else { return }
        photoImageView.getImageData(url: imageUrl)
    }

    private func setPhotoImageViewConstraints() {
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            photoImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30)
        ])
    }

    private func setNameActorLabelConstraints() {
        NSLayoutConstraint.activate([
            nameActorLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor),
            nameActorLabel.centerXAnchor.constraint(equalTo: photoImageView.centerXAnchor),
            nameActorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            nameActorLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9)
        ])
    }
}
