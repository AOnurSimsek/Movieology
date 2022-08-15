//
//  ActorDetailViewModel.swift
//  Movieology
//
//  Created by Abdullah onur Şimşek on 12.08.2022.
//

import UIKit

enum ActorDetailTextTypes {
    case birthday
    case biography
}

final class ActorDetailViewModel: BaseViewModel {
    
    var actorID: Int?
    
    var actorDetails: Observable<ActorDetailModel?> = Observable(nil)
    var actorCasts: Observable<ActorMovieCreditsModel?> = Observable(nil)
    var error: Observable<customErrors?> = Observable(nil)
    
    func getData() {
        getActorCasts()
        getActorDetails()
    }
    
    private func getActorDetails() {
        WebService.shared.request(type: .actorDetail,
                                  actorID: actorID,
                                  successHandler: handleActorDetail(_:),
                                  errorHandler: handleError(_:))
    }
    
    private func getActorCasts() {
        WebService.shared.request(type: .actorMovies,
                                  actorID: actorID,
                                  successHandler: handleActorCast(_:),
                                  errorHandler: handleError(_:))
    }
    
    private func handleActorDetail(_ response: ActorDetailModel) {
        actorDetails.value = response
    }
    
    private func handleActorCast(_ response: ActorMovieCreditsModel) {
        actorCasts.value = response
    }
    
    private func handleError(_ _error: customErrors) {
        error.value = _error
    }
    
    func getRowCount() -> Int {
        return actorCasts.value?.cast?.count ?? 0
    }
    
    func getNameText() -> String {
        return actorDetails.value?.name ?? ""
    }
    
    func getAttributedText(type: ActorDetailTextTypes) -> NSMutableAttributedString {
        switch type {
        case .birthday:
            if let birthday = actorDetails.value?.birthday {
                let birthPlace = actorDetails.value?.placeOfBirth
                return birthday.getTitleAttributedString(text: birthday + "\n" + birthPlace~, hightlightedText: "Birthday: ")
            } else {
                return String().getTitleAttributedString(text: "\tNot Found", hightlightedText: "Birthday:")
            }
        case .biography:
            if let biography = actorDetails.value?.biography {
                return biography.getTitleAttributedString(text: biography~, hightlightedText: "Biography:\n\t")
            } else {
                return String().getTitleAttributedString(text: "Not found", hightlightedText: "Biogrpahy:\n\t")
            }
        }
    }
    
    func getImage(to: UIImageView) {
        if let imageUrl = actorDetails.value?.profilePath {
            let url = URL(string: "https://image.tmdb.org/t/p/w500" + (imageUrl))
            to.kf.setImage(with: url)
        } else {
            to.image = UIImage(named: "placeholderImage")
        }
    }
    
    func getWebsiteStatus() -> Bool {
        if let _ = actorDetails.value?.homepage {
            return true
        } else {
            return false
        }
    }
    
    func getURL(type: DetailUrlTypes) -> URL? {
        switch type {
        case .website:
            return URL(string: actorDetails.value?.homepage ?? "")
        case .imdb:
            var urlString: String = ""
            if let imdbKey = actorDetails.value?.imdbID {
                let base: String = "https://www.imdb.com/name/"
                urlString = base + imdbKey
            } else {
                urlString = "https://www.imdb.com/"
            }
            return URL(string: urlString)
        case .videos:
            fatalError("ActorDetailViewModel video url type")
        }
    }
    
    func getCollectionViewCell(collectionview: UICollectionView,
                               indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: ActorCastCollectionViewCell.identifier,
                                                      for: indexPath) as! ActorCastCollectionViewCell
        cell.setCell(image: URL(string: "https://image.tmdb.org/t/p/w500" + (actorCasts.value?.cast?[indexPath.row].posterPath ?? "")),
                     movieName: actorCasts.value?.cast?[indexPath.row].title ?? "",
                     movieCharacter: actorCasts.value?.cast?[indexPath.row].character ?? "")
        return cell
    }
    
    func getMovieID(index: Int) -> Int {
        if let id = actorCasts.value?.cast?[index].id {
            return id
        } else {
            return 0
        }
    }
}
