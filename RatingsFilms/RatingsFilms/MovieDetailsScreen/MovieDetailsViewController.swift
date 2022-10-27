// MovieDetailsViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Screen with film details
final class MovieDetailsViewController: UIViewController {
    // MARK: Constants

    private enum Constants {
        static let movieDetailsCellName = "movieDetailsCell"
        static let backgoundColorName = "backgroundColor"
        static let textColorName = "textColor"
        static let startUrlText = "https://image.tmdb.org/t/p/w300"
    }

    // MARK: Visual Components

    private let movieDetailsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MovieDetailsCell.self, forCellReuseIdentifier: Constants.movieDetailsCellName)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

//    private lazy var movieImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: Constants.startUrlText + (currnetMovie?.image ?? ""))
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//
//    private lazy var movieOverviewTextview: UITextView = {
//        let textView = UITextView()
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        textView.contentInsetAdjustmentBehavior = .automatic
//        textView.text = currnetMovie?.overview
//        textView.textColor = UIColor(named: Constants.textColorName)
//        return textView
//    }()
//
//    private lazy var moreDetailTextView: UITextView = {
//        let textView = UITextView()
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        textView.contentInsetAdjustmentBehavior = .automatic
//        textView.text = """
    // Дата выхода фильма: \(currnetMovie?.realeaseDate ?? "Неизвестно")
    // Рейтинг фильма: \(currnetMovie?.raiting ?? 0)
    // """
//        textView.textColor = UIColor(named: Constants.textColorName)
//        return textView
//    }()

//    // MARK: Private Properties
//
    private let networkService = NetworkService()

    // MARK: Private Properties

    var currnetMovie: Movie?

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }

    // MARK: Private Methods

    private func configUI() {
        view.backgroundColor = UIColor(named: Constants.backgoundColorName)
        navigationController?.navigationBar.tintColor = .orange
        movieDetailsTableView.dataSource = self
        view.addSubview(movieDetailsTableView)
        setConstraintsTableView()
        // view.addSubview(movieImageView)
        // setMovieImageViewConstraints()
        // view.addSubview(movieOverviewTextview)
        // setMovieOverviewTextViewConstraints()
        guard let id = currnetMovie?.movieId else { return }
        networkService.loadFilmInformationById(id: id) { [weak self] movieDetail in
            switch movieDetail {
            case .failure(.urlError):
                print("url error")
            case .failure(.decodingError):
                print("decoding error")
            case .failure(.unknownError):
                print("unknown error")
            case let .success(movie: movieDetail):
                self?.currnetMovie = movieDetail
                self?.movieDetailsTableView.reloadData()
//                guard let endUrlImage = movieDetail.image
//                else { return }
//                guard let currentImageUrl = URL(
//                    string: Constants.startUrlText + endUrlImage
//                )
//                else { return }
                // self?.movieImageView.getImageData(url: currentImageUrl)
            }
        }
    }

//    private func setDetails(movie: Movie) {}

    private func setConstraintsTableView() {
        NSLayoutConstraint.activate([
            movieDetailsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            movieDetailsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieDetailsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            movieDetailsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

//    private func setMovieImageViewConstraints() {
//        NSLayoutConstraint.activate([
//            movieImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            movieImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
//            movieImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
//            movieImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
//        ])
//    }
//
//    private func setMovieOverviewTextViewConstraints() {
//        NSLayoutConstraint.activate([
//            movieOverviewTextview.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 5),
//            movieOverviewTextview.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            movieOverviewTextview.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
//            movieOverviewTextview.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
//        ])
//    }
}

// MARK: UITableViewDataSource

extension MovieDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.movieDetailsCellName,
            for: indexPath
        ) as? MovieDetailsCell
        else { return UITableViewCell() }
        guard let currentMovieDetail = currnetMovie else { return UITableViewCell() }
        cell.setCell(movie: currentMovieDetail)
        return cell
    }
}
