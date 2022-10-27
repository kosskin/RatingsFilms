// SearchFilmViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Screen with list of films and different categories
final class SearchFilmViewController: UIViewController {
    // MARK: Constants

    private enum Constants {
        static let movieCellId = "movieCell"
        static let popularButtonText = "Популярные"
        static let topRatingButtonText = "Топ рейтинга"
        static let upcomingButtonText = "Премьеры"
        static let backgoundColorName = "backgroundColor"
        static let textColorName = "textColor"
        static let startUrlText = "https://image.tmdb.org/t/p/w300"
        static let popularUrl =
            "https://api.themoviedb.org/3/movie/popular?api_key=74448ef651b5d6b0af58f8899305190d&language=en-US&page=1"
        static let topRatingUrl =
            "https://api.themoviedb.org/3/movie/top_rated?api_key=74448ef651b5d6b0af58f8899305190d&language=en-US&page=1"
        static let upcomingUrl =
            "https://api.themoviedb.org/3/movie/upcoming?api_key=74448ef651b5d6b0af58f8899305190d&language=en-US&page=1"
    }

    // MARK: Visual Components

    private let popularButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.popularButtonText, for: .normal)
        button.setTitleColor(UIColor(named: Constants.backgoundColorName), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.tag = 0
        button.backgroundColor = .orange
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(sortingButtonAction(sender:)), for: .touchUpInside)
        return button
    }()

    private let topRatingButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.topRatingButtonText, for: .normal)
        button.setTitleColor(UIColor(named: Constants.backgoundColorName), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.tag = 1
        button.backgroundColor = .orange
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(sortingButtonAction(sender:)), for: .touchUpInside)
        return button
    }()

    private let upcomingButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.upcomingButtonText, for: .normal)
        button.setTitleColor(UIColor(named: Constants.backgoundColorName), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.tag = 2
        button.backgroundColor = .orange
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(sortingButtonAction(sender:)), for: .touchUpInside)
        return button
    }()

    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [popularButton, topRatingButton, upcomingButton])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 3
        return stackView
    }()

    private let searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MovieCell.self, forCellReuseIdentifier: Constants.movieCellId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: Private Properties

    private var movies = MoviesList(moviesList: [])
    private let networkService = NetworkService()

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }

    // MARK: Private Methods

    private func configUI() {
        searchTableView.dataSource = self
        searchTableView.delegate = self
        view.addSubview(buttonsStackView)
        setConstraintsStackView()
        view.addSubview(searchTableView)
        setConstraintsTableView()
        networkService.loadFilmInformation(filmUrl: Constants.popularUrl) { [weak self] movieList in
            switch movieList {
            case let .success(movies: incomingMoviesList):
                self?.movies = incomingMoviesList
                self?.searchTableView.reloadData()
            case let .failure(error):
                print("Request failed \(error)")
            }
        }
    }

    private func setConstraintsTableView() {
        NSLayoutConstraint.activate([
            searchTableView.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 10),
            searchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            searchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setConstraintsStackView() {
        NSLayoutConstraint.activate([
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            buttonsStackView.widthAnchor.constraint(equalToConstant: 300),
            buttonsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    @objc private func sortingButtonAction(sender: UIButton) {
        switch sender.tag {
        case 0:
            networkService.loadFilmInformation(filmUrl: Constants.popularUrl) { [weak self] result in
                switch result {
                case let .success(movies: result):
                    self?.movies = result
                    self?.searchTableView.reloadData()
                case let .failure(error):
                    print("Request failed \(error)")
                }
            }
        case 1:
            networkService.loadFilmInformation(filmUrl: Constants.topRatingUrl) { [weak self] result in
                switch result {
                case let .success(movies: result):
                    self?.movies = result
                    self?.searchTableView.reloadData()
                case let .failure(error):
                    print("Request failed \(error)")
                }
            }
        case 2:
            networkService.loadFilmInformation(filmUrl: Constants.upcomingUrl) { [weak self] result in
                switch result {
                case let .success(movies: result):
                    self?.movies = result
                    self?.searchTableView.reloadData()
                case let .failure(error):
                    print("Request failed \(error)")
                }
            }
        default: break
        }
    }
}

// MARK: UITableViewDataSource

extension SearchFilmViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.moviesList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.movieCellId,
            for: indexPath
        ) as? MovieCell
        else { return UITableViewCell() }
        let movie = movies.moviesList[indexPath.row]
        cell.setCell(movie: movie)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currnetMovie = movies.moviesList[indexPath.row]
        let movieDetailsVC = MovieDetailsViewController()
        movieDetailsVC.currnetMovie = currnetMovie
        navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
}
