//
//  MovieDetailModel.swift
//  Movieology
//
//  Created by Abdullah onur Şimşek on 11.08.2022.
//

import Foundation

struct MovieDetailModel: Codable {

    var backdropPath: String?
    var releaseDate: String?
    var genres: [Genre]?
    var homepage: String?
    var imdbID: String?
    var title: String?
    var overview: String?
    var posterPath: String?
    var status: String?
    var id: Int?
    var voteCount: Int?
    var runtime: Int?
    var voteAverage: Double?
    var success: Bool?
    var statusCode: Int?
    var statusMessage: String?

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case genres
        case homepage
        case id
        case title
        case overview
        case success
        case runtime
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case imdbID = "imdb_id"
        case statusCode = "status_code"
        case statusMessage = "status_message"

    }

}

struct Genre: Codable {
    var id: Int?
    var name: String?

}
