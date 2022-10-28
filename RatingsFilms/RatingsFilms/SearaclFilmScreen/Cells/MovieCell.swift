// MovieCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// describe one cell with movie and information about movie
final class MovieCell: UITableViewCell {
    // MARK: Constants

    private enum Constants {
        static let backgoundColorName = "backgroundColor"
        static let textColorName = "textColor"
        static let startUrlText = "https://image.tmdb.org/t/p/w300"
    }

    // MARK: Visual Components

    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()

    private let nameMovieButton: UIButton = {
        let label = UIButton()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setTitleColor(UIColor(named: Constants.textColorName), for: .normal)
        label.backgroundColor = .green
        label.addTarget(self, action: #selector(showMovieDetailsAction(sender:)), for: .touchUpInside)
        return label
    }()

    private let raitingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .orange
        label.font = UIFont.systemFont(ofSize: 16)
        label.layer.cornerRadius = 14
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.textColor = UIColor(named: Constants.backgoundColorName)
        return label
    }()

    private let overviewFilmTextFiew: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 12)
        textView.textColor = UIColor(named: Constants.textColorName)
        return textView
    }()

    // MARK: Public Properties

    weak var delegate: PushDelegate?

    // MARK: Private Properties

    private var movieToNextVC: Movie?

    // MARK: Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public Methods

    func setCell(movie: Movie) {
        nameMovieButton.setTitle(movie.title, for: .normal)
        overviewFilmTextFiew.text = movie.overview

        guard let raiting = movie.raiting else { return }
        raitingLabel.text = String(raiting)

        guard let imageName = movie.image else { return }

        let urlString = Constants.startUrlText + imageName
        guard let imageUrl = URL(string: urlString) else { return }
        movieImageView.getImageData(url: imageUrl)
        movieToNextVC = movie
    }

    // MARK: Private Methods

    @objc func showMovieDetailsAction(sender: UIButton) {
        print(#function)
        guard let notOptMovie = movieToNextVC else { return }
        delegate?.pushOnVC(movie: notOptMovie)
    }

    private func configUI() {
        backgroundColor = UIColor(named: Constants.backgoundColorName)
        movieImageView.addSubview(raitingLabel)
        contentView.addSubview(movieImageView)
        contentView.addSubview(nameMovieButton)
        addSubview(overviewFilmTextFiew)

        NSLayoutConstraint.activate([
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            movieImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            movieImageView.heightAnchor.constraint(equalTo: movieImageView.widthAnchor, multiplier: 1.3),

            nameMovieButton.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 5),
            nameMovieButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            nameMovieButton.heightAnchor.constraint(equalTo: movieImageView.heightAnchor, multiplier: 0.2),
            nameMovieButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 5),

            raitingLabel.rightAnchor.constraint(equalTo: movieImageView.rightAnchor, constant: -5),
            raitingLabel.widthAnchor.constraint(equalTo: movieImageView.widthAnchor, multiplier: 0.22),
            raitingLabel.heightAnchor.constraint(equalTo: raitingLabel.widthAnchor),
            raitingLabel.bottomAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: -5),

            overviewFilmTextFiew.topAnchor.constraint(equalTo: nameMovieButton.bottomAnchor, constant: 2),
            overviewFilmTextFiew.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 10),
            overviewFilmTextFiew.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            overviewFilmTextFiew.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}
