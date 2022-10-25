// Data.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

final class MovieModel {
    private var networkServie = NetworkService()
    var allMovies: [Movie] = []
    var filmUrl =
        "https://api.themoviedb.org/3/movie/popular?api_key=74448ef651b5d6b0af58f8899305190d&language=en-US&page=1"

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
