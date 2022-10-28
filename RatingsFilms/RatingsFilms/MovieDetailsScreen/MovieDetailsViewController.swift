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
        static let favoriteText = "Вы добавили фильм в избранное"
        static let okText = "Ok"
        static let unknownErrorText = "unknown error"
        static let urlErrorText = "url error"
        static let decodingText = "decoding error"
    }

    // MARK: Visual Components

    private let movieDetailsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MovieDetailsCell.self, forCellReuseIdentifier: Constants.movieDetailsCellName)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

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
        setNavigationBar()
        movieDetailsTableView.dataSource = self
        view.addSubview(movieDetailsTableView)
        setConstraintsTableView()
        guard let id = currnetMovie?.movieId else { return }
        networkService.loadFilmInformationById(id: id) { [weak self] movieDetail in
            switch movieDetail {
            case .failure(.urlError):
                print(Constants.urlErrorText)
            case .failure(.decodingError):
                print(Constants.decodingText)
            case .failure(.unknownError):
                print(Constants.unknownErrorText)
            case let .success(movie: movieDetail):
                self?.currnetMovie = movieDetail
                self?.movieDetailsTableView.reloadData()
            }
        }
    }

    private func setNavigationBar() {
        navigationController?.navigationBar.tintColor = .orange
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(getAlertAction(sender:))
        )
    }

    private func setConstraintsTableView() {
        NSLayoutConstraint.activate([
            movieDetailsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            movieDetailsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieDetailsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            movieDetailsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    @objc func getAlertAction(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: Constants.favoriteText, message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: Constants.okText, style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
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
