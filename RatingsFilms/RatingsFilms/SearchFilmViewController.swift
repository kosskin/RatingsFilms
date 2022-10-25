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
    }

    // MARK: Visual Components

    private let popularButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.popularButtonText, for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.tag = 1
        button.addTarget(self, action: #selector(sortingButtonAction(sender:)), for: .touchUpInside)
        return button
    }()

    private let topRatingButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.topRatingButtonText, for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.tag = 2
        button.addTarget(self, action: #selector(sortingButtonAction(sender:)), for: .touchUpInside)
        return button
    }()

    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [popularButton, topRatingButton])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        return stackView
    }()

    private let searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MovieCell.self, forCellReuseIdentifier: Constants.movieCellId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: Private Properties

    private var movieModel = MovieModel()

    @objc private func sortingButtonAction(sender: UIButton) {
        switch sender.tag {
        case 1:
            let url =
                "https://api.themoviedb.org/3/movie/popular?api_key=74448ef651b5d6b0af58f8899305190d&language=en-US&page=1"
            movieModel.filmUrl = url
            loadMoviesData()
        case 2:
            let url =
                "https://api.themoviedb.org/3/movie/top_rated?api_key=74448ef651b5d6b0af58f8899305190d&language=en-US&page=1"
            movieModel.filmUrl = url
            loadMoviesData()
        default:
            break
        }
    }

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        loadMoviesData()
    }

    // MARK: Private Methods

    private func configUI() {
        searchTableView.dataSource = self
        view.addSubview(buttonsStackView)
        setConstraintsStackView()
        view.addSubview(searchTableView)
        setConstraintsTableView()
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
            buttonsStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func loadMoviesData() {
        movieModel.fetchData(completion: { [weak self] in
            DispatchQueue.main.async {
                self?.searchTableView.reloadData()
            }
        })
    }
}

// MARK: UITableViewDataSource

extension SearchFilmViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movieModel.allMovies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.movieCellId,
            for: indexPath
        ) as? MovieCell
        else { return UITableViewCell() }
        let movie = movieModel.cellForRowAt(indexPath: indexPath)
        cell.setCell(movie: movie)
        return cell
    }
}
