//
//  VideoModel.swift
//  Movieology
//
//  Created by Abdullah onur Şimşek on 11.08.2022.
//

import Foundation

struct VideosModel: Codable {

    var id: Int?
    var results: [VideoResult]?
    var success: Bool?
    var statusCode: Int?
    var statusMessage: String?

    enum CodingKeys: String, CodingKey {
        case id
        case results
        case success
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

struct VideoResult: Codable {
    var name: String?
    var key: String?
    var site: String?
    var type: String?

}
