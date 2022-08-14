//
//  MovieDetailViewModel.swift
//  Movieology
//
//  Created by Abdullah onur Şimşek on 12.08.2022.
//

import Foundation
import Kingfisher

enum ImageType {
    case backdrop
    case poster
}

enum DetailUrlTypes {
    case website
    case videos
    case imdb
}

enum TextType {
    case title
    case overview
    case vote
}

enum AttributedTextType {
    case genres
    case overview
    case runtime
    case releasedate
}

class MovieDetailViewModel: BaseViewModel {
    var movieID: Int?
    
    var movieDetails: Observable<MovieDetailModel?> = Observable(nil)
    var movieCredits: Observable<MovieCreditsModel?> = Observable(nil)
    var movieVideos: Observable<VideosModel?> = Observable(nil)

    var error: Observable<customErrors?> = Observable(nil)
    
    func getDetails() {
        getMovie()
        getTrailers()
        getCasts()
    }
    
    private func getMovie() {
        WebService.shared.request(type: .movieDetail,
                                  movieID: movieID,
                                  successHandler: handlePopularMovies(_:),
                                  errorHandler: handleError(_:))
    }
    
    private func getCasts() {
        WebService.shared.request(type: .movieCredits,
                                  movieID: movieID,
                                  successHandler: handleCredits(_:),
                                  errorHandler: handleError(_:))
    }
    
    private func getTrailers() {
        WebService.shared.request(type: .trailer,
                                  movieID: movieID,
                                  successHandler: handleTrailer(_:),
                                  errorHandler: handleError(_:))
    }
    
    private func handleCredits(_ response: MovieCreditsModel) {
        movieCredits.value = response
    }
    
    private func handleTrailer(_ response: VideosModel) {
        movieVideos.value = response
    }
    
    private func handlePopularMovies(_ response: MovieDetailModel) {
        movieDetails.value = response
    }
    
    private func handleError(_ _error: customErrors) {
        error.value = _error
    }
    
    func getImage(to: UIImageView, imageType: ImageType ) {
        var url: URL?
        
        switch imageType {
        case .backdrop:
            url = URL(string: "https://image.tmdb.org/t/p/w500" + (movieDetails.value?.backdropPath ?? ""))
        case .poster:
            url = URL(string: "https://image.tmdb.org/t/p/w500" + (movieDetails.value?.posterPath ?? ""))
        }
        
        to.kf.setImage(with: url, placeholder: UIImage(named: "placeholderImage"))
    }
    
    func getText(type: TextType) -> String {
        guard let model = movieDetails.value
        else { return "" }
        
        switch type {
        case .title:
            return model.title~
        case .overview:
            return model.overview~
        case .vote:
            return String(format: "%.1f/10", model.voteAverage~)
        }
    }
    
    func getAttributedText(type: AttributedTextType) -> NSMutableAttributedString {
        guard let model = movieDetails.value
        else { return NSMutableAttributedString(string: "", attributes: nil) }
        
        switch type {
        case .genres:
            var genres: String = ""
            if let movieGenres = model.genres {
                for genre in movieGenres {
                    genres += ", " +  genre.name~
                }
            }
            genres.removeFirst()
            return genres.getTitleAttributedString(text: genres, hightlightedText: "Genres: ")
        case .overview:
            guard let overview = model.overview
            else { return NSMutableAttributedString(string: "", attributes: nil) }
            
            return overview.getTitleAttributedString(text: overview, hightlightedText: "Overview:\n\t")
        case .runtime:
            guard let runtime = model.runtime
            else { return NSMutableAttributedString(string: "", attributes: nil) }
            
            let hour = runtime / 60
            let minutes = runtime % 60
            let stringRuntime = "\(hour)h \(minutes)min"
            return stringRuntime.getTitleAttributedString(text: stringRuntime, hightlightedText: "Runtime: ")
        case .releasedate:
            guard let releaseDate = model.releaseDate
            else { return NSMutableAttributedString(string: "", attributes: nil) }
            
            return releaseDate.getTitleAttributedString(text: releaseDate.getDate(), hightlightedText: "Release Date: ")
        }
    }
    
    func getCollectionViewCell(collectionView: UICollectionView,
                               indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.identifier,
                                                      for: indexPath) as! CastCollectionViewCell
        cell.setCell(image: URL(string: "https://image.tmdb.org/t/p/w500" + (movieCredits.value?.cast?[indexPath.row].profilePath ?? "")),
                     name: movieCredits.value?.cast?[indexPath.row].name ?? "")
        return cell
    }
    
    func getRowCount() -> Int {
        return movieCredits.value?.cast?.count ?? 0
    }
    
    func getURL(type: DetailUrlTypes) -> URL? {
        switch type {
        case .website:
            return URL(string: movieDetails.value?.homepage ?? "")
        case .videos:
            var urlString : String = ""
            if let key = movieVideos.value?.results?.first?.key {
                let base: String = "https://www.youtube.com/watch?v="
                urlString = base + key
            } else {
                urlString = "https://www.youtube.com/"
            }
            return URL(string: urlString)
        case .imdb:
            var urlString: String = ""
            if let imdbKey = movieDetails.value?.imdbID {
                let base: String = "https://www.imdb.com/title/"
                urlString = base + imdbKey
            } else {
                urlString = "https://www.imdb.com/"
            }
            return URL(string: urlString)
        }
    }
    
}
