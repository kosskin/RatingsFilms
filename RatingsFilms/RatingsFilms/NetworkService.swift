// NetworkService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

final class NetworkService {
    // MARK: Private Properties

    private var dataTask: URLSessionDataTask?

    // MARK: Public Methods

    func loadFilmInformation(filmUrl: String, completion: @escaping (Result<MoviesList, Error>) -> ()) {
        guard let url =
            URL(
                string: filmUrl
            )
        else { return }
        dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                print("Do not have data")
                return
            }
            do {
                let result = try JSONDecoder().decode(MoviesList.self, from: data)
                completion(.success(result))
                print("\(result)")
            } catch {
                completion(.failure(error))
            }
        }
        dataTask?.resume()
    }
}
