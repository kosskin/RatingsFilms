// Data.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

final class MovieModel {
    // MARK: Constants

    private enum Constants {
        static let startUrl =
            "https://api.themoviedb.org/3/movie/popular?api_key=74448ef651b5d6b0af58f8899305190d&language=en-US&page=1"
    }

    // MARK: Private Properties

    private var networkServie = NetworkService()

    // MARK: Public Properties

    var allMovies: [Movie] = []
    var filmUrl = Constants.startUrl

    // MARK: Public Methods

    func fetchData(completion: @escaping () -> ()) {
        networkServie.loadFilmInformation(filmUrl: filmUrl) { [weak self] arrayq in
            switch arrayq {
            case let .success(successMoviesData):
                self?.allMovies = successMoviesData.moviesList
                completion()
            case let .failure(error):
                print(error)
            }
        }
    }

    func cellForRowAt(indexPath: IndexPath) -> Movie {
        allMovies[indexPath.row]
    }
}
