// ActorInfo.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Model of list actors
struct ActorList: Decodable {
    let actor: [Actor]

    private enum CodingKeys: String, CodingKey {
        case actor = "cast"
    }
}

/// Model of actor
struct Actor: Decodable {
    let name: String?
    let actorImage: String?

    private enum CodingKeys: String, CodingKey {
        case name
        case actorImage = "profile_path"
    }
}
