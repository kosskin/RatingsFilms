// NetworkService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Type of errors
enum NetworkError: Error {
    case urlError
    case decodingError
    case unknownError
}

/// The type of request list of movies(success or error)
enum SuccessFailureResult {
    case success(movies: MoviesList)
    case failure(NetworkError)
}

/// The type of request one movie(success or error)
enum SuccessFailureResultMovie {
    case success(movie: Movie)
    case failure(NetworkError)
}

/// Service with intetnet request
final class NetworkService {
    // MARK: Constants

    private enum Constants {
        static let startUrlWithId = "https://api.themoviedb.org/3/movie/"
        static let endUrlWithId = "?api_key=74448ef651b5d6b0af58f8899305190d&language=en-US"
    }

    // MARK: Private Properties

    private let session = URLSession.shared

    // MARK: Public Methods

    func loadFilmInformation(filmUrl: String, completion: @escaping (SuccessFailureResult) -> ()) {
        guard let url = URL(string: filmUrl) else {
            completion(.failure(.urlError))
            return
        }
        print(url)
        session.dataTask(with: url) { data, _, _ in
            var resultOfDecoding: SuccessFailureResult
            defer {
                DispatchQueue.main.async {
                    completion(resultOfDecoding)
                }
            }
            if let data = data {
                guard let moviesList = try? JSONDecoder().decode(MoviesList.self, from: data) else {
                    resultOfDecoding = .failure(.decodingError)
                    return
                }
                resultOfDecoding = .success(movies: moviesList)
            } else {
                resultOfDecoding = .failure(.unknownError)
            }
        }.resume()
    }

    func loadFilmInformationById(id: Int, completion: @escaping (SuccessFailureResultMovie) -> ()) {
        guard let url = URL(string: Constants.startUrlWithId + String(id) + Constants.endUrlWithId) else {
            completion(.failure(.urlError))
            return
        }
        print(url)
        session.dataTask(with: url) { data, _, _ in
            var resultOfDecoding: SuccessFailureResultMovie
            defer {
                DispatchQueue.main.async {
                    completion(resultOfDecoding)
                }
            }
            if let data = data {
                print(data)
                guard let movie = try?
                    JSONDecoder().decode(Movie.self, from: data)
                else {
                    resultOfDecoding = .failure(.decodingError)
                    return
                }
                resultOfDecoding = .success(movie: movie)
            } else {
                resultOfDecoding = .failure(.unknownError)
            }
        }.resume()
    }
}
