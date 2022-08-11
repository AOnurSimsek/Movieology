//
//  PopularMoviesModel.swift
//  Movieology
//
//  Created by Abdullah onur Şimşek on 11.08.2022.
//

import Foundation

struct PopularMoviesModel: Codable {

    var page: Int?
    var results: [MovieModel]?
    var totalPages: Int?
    var totalResults: Int?
    var success: Bool?
    var statusCode: Int?
    var statusMessage: String?

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case success
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }

}

struct MovieModel: Codable {

    var backdropPath: String?
    var releaseDate: String?
    var genreIds: [Int]?
    var id: Int?
    var voteCount: Int?
    var title: String?
    var originalLanguage: String?
    var originalTitle: String?
    var overview: String?
    var posterPath: String?
    var popularity: Double?
    var voteAverage: Double?

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
        case id
        case title
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

}
