//
//  WebService.swift
//  Movieology
//
//  Created by Abdullah onur Şimşek on 11.08.2022.
//

import Foundation
import Alamofire

final class WebService {
    static let shared = WebService()

    private static let apiKey : String = "726e15f3daf1de3b57996b8991c6e42f"
    private static let baseURL: String = "https://api.themoviedb.org/3/"

    private func isReachable() ->  Bool {
        let isReachable = NetworkReachabilityManager()?.isReachable
        return isReachable~
    }

    private func getUrl(type: urlType, movieID: Int? = nil, actorID: Int? = nil, page: Int? = nil, searchText: String? = nil) -> URL? {
        switch type {
        case .movieDetail:
            return URL(string: WebService.baseURL + "movie/" + "\(movieID~)" + "?api_key=\(WebService.apiKey)")
        case .popularMovies:
            return URL(string: WebService.baseURL + "movie/popular" + "?api_key=\(WebService.apiKey)" + "&page=\(page~)")
        case .search:
            return URL(string: WebService.baseURL + "search/multi" + "?api_key=\(WebService.apiKey)" + "&query=\(searchText~)" + "&page=\(page~)")
        case .movieCredits:
            return URL(string: WebService.baseURL + "movie/\(movieID~)/credits" + "?api_key=\(WebService.apiKey)")
        case .actorDetail:
            return URL(string: WebService.baseURL + "person/" + "\(actorID~)" + "?api_key=\(WebService.apiKey)")
        case .actorMovies:
            return URL(string: WebService.baseURL + "person/\(actorID~)/movie_credits" + "?api_key=\(WebService.apiKey)")
        case .trailer:
            return URL(string: WebService.baseURL + "movie/\(movieID~)/videos" + "?api_key=\(WebService.apiKey)")

        }
    }

    func request<S: Codable>(type: urlType,
                             movieID: Int? = nil,
                             actorID: Int? = nil,
                             page: Int? = 1,
                             searchText: String? = "",
                             successHandler: @escaping ((S)->Void),
                             errorHandler: @escaping ((webServiceErrors)->Void)) {
        if !isReachable() {
            errorHandler(.internetError)
            return
        }

        guard let url = getUrl(type: type,
                               movieID: movieID,
                               actorID: actorID,
                               page: page,
                               searchText: searchText)
        else {
            errorHandler(.urlError)
            return
        }
        AF.request(url, method: .get).responseDecodable(of: S.self) { response in
            if let error = response.error {
                print("🛑 error occured at get request. Error : " + error.localizedDescription)
                errorHandler(.apiError)
                return
            } else {
                if let value = response.value {
                    successHandler(value)
                } else {
                    errorHandler(.unknown)
                }
            }
        }
    }

}
