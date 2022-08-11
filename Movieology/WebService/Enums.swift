//
//  Enums.swift
//  Movieology
//
//  Created by Abdullah onur Şimşek on 11.08.2022.
//

enum urlType {
    case movieDetail
    case popularMovies
    case search
    case movieCredits
    case actorDetail
    case actorMovies
    case trailer

}

enum webServiceErrors: CustomStringConvertible {
    case internetError
    case apiError
    case urlError
    case unknown

    var description: String {
        switch self {
        case .internetError:
            return "Internet connection error occured. Check your connection and try again"
        case .apiError:
            return "Service error occured. Please try again later"
        case .urlError:
            return "Url failed. Contact with us"
        case .unknown:
            return "An unknown error occured. Please try again later"
        }
    }

}
