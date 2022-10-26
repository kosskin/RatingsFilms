// NetworkService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Type of errors
enum NetworkError: Error {
    case urlError
    case decodingError
    case unknownError
}

/// The type of request(success of error)
enum SuccessFailureResult {
    case success(movies: MoviesList)
    case failure(NetworkError)
}

/// Service with intetnet request
final class NetworkService {
    // MARK: Private Properties

    private let session = URLSession.shared

    // MARK: Public Methods

    func loadFilmInformation(filmUrl: String, completion: @escaping (SuccessFailureResult) -> ()) {
        guard let url = URL(string: filmUrl) else {
            completion(.failure(.urlError))
            return
        }
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
}
