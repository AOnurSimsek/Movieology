//
//  SearchModel.swift
//  Movieology
//
//  Created by Abdullah onur Şimşek on 11.08.2022.
//

import Foundation

struct SearchModel: Codable {

    var page: Int?
    var results: [SearchResult]?
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

struct SearchResult: Codable {

    var id: Int?
    var name: String?
    var title: String?
    var overview: String?
    var mediaType: String?
    var posterPath: String?
    var profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case title
        case overview
        case mediaType = "media_type"
        case posterPath = "poster_path"
        case profilePath = "profile_path"
    }
}
