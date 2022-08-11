//
//  ActorMovieCreditsModel.swift
//  Movieology
//
//  Created by Abdullah onur Şimşek on 11.08.2022.
//

import Foundation

struct ActorMovieCreditsModel: Codable {

    var id: Int?
    var cast: [ActorCast]?
    var success: Bool?
    var statusCode: Int?
    var statusMessage: String?

    enum CodingKeys: String, CodingKey {
        case id
        case cast
        case success
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

struct ActorCast: Codable {

    var backdropPath: String?
    var id: Int?
    var overview: String?
    var posterPath: String?
    var title: String?
    var character: String?

    enum CodingKeys: String, CodingKey {
        case id
        case overview
        case title
        case character
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
    }
}
