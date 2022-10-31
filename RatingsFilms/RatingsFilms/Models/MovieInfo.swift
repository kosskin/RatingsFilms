// MovieInfo.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Model for get movies array from server
struct MoviesList: Decodable {
    let movies: [Movie]

    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

/// Model describe one movie in API
struct Movie: Decodable {
    let movieId: Int?
    let overview: String?
    let raiting: Double?
    let title: String?
    let image: String?
    let realeaseDate: String?

    enum CodingKeys: String, CodingKey {
        case movieId = "id"
        case overview
        case raiting = "vote_average"
        case title
        case image = "poster_path"
        case realeaseDate = "release_date"
    }
}
