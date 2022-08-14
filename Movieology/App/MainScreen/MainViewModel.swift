//
//  MainViewModel.swift
//  Movieology
//
//  Created by Abdullah onur Şimşek on 12.08.2022.
//

import Foundation
import UIKit

class MainScreenViewModel: BaseViewModel {

    private var currentPage: Int = 1
    private var maxPage: Int = 0
    var error: Observable<customErrors?> = Observable(nil)
    var popularMovies: Observable<[MovieModel]> = Observable([])
    var searchResults: Observable<[[SearchResult]]> = Observable([])

    func getPopularMovies(isNextPage: Bool = false) {
        if isNextPage && currentPage <= maxPage {
            currentPage += 1
            WebService.shared.request(type: .popularMovies,
                                      page: currentPage,
                                      successHandler: handlePopularMovies(_:),
                                      errorHandler: handleError(_:))
        } else {
            currentPage = 1
            WebService.shared.request(type: .popularMovies,
                                      successHandler: handlePopularMovies(_:),
                                      errorHandler: handleError(_:))
        }
    }

    func search(text: String) {
        WebService.shared.request(type: .search,
                                  searchText: text,
                                  successHandler: handleSearch(_:),
                                  errorHandler: handleError(_:))
    }

    private func handlePopularMovies(_ response: PopularMoviesModel) {
        if currentPage == 1 {
            popularMovies.value = response.results ?? []
            self.maxPage = response.totalPages ?? -1
        } else {
            if let movies = response.results {
                popularMovies.value.append(contentsOf: movies)
            } else {
                handleError(webServiceErrors.unknown)
            }
        }
    }

    private func handleSearch(_ response: SearchModel) {
        var searchResultArray: [[SearchResult]] = [[],[],[]]
        if let result = response.results {
            for item in result {
                if item.mediaType == "tv"{
                    searchResultArray[0].append(item)
                } else if item.mediaType == "movie" {
                    searchResultArray[1].append(item)
                } else if item.mediaType == "person" {
                    searchResultArray[2].append(item)
                }
            }
        }
        self.searchResults.value = searchResultArray
    }

    private func handleError(_ _error: customErrors) {
        error.value = _error
    }

    func getRowCount(screenState: MainScreenState, section: Int) -> Int {
        switch screenState {
        case .popularMovies:
            return popularMovies.value.count
        case .nextPage:
            return popularMovies.value.count
        case .search:
            return searchResults.value[section].count
        }
    }

    func getSectionCount(screenState: MainScreenState) -> Int {
        switch screenState {
        case .popularMovies:
            return 1
        case .nextPage:
            return 1
        case .search:
            return searchResults.value.count
        }
    }

    func getCell(tableView: UITableView, indexPath: IndexPath, screenState: MainScreenState) -> UITableViewCell {
        switch screenState {
        case .popularMovies:
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier,
                                                     for: indexPath) as! MovieTableViewCell
            cell.setCell(image: URL(string: "https://image.tmdb.org/t/p/w500" + (popularMovies.value[indexPath.row].posterPath ?? "")),
                         title: popularMovies.value[indexPath.row].originalTitle ?? "",
                         description: popularMovies.value[indexPath.row].overview ?? "")
            cell.selectionStyle = .none
            return cell
        case .nextPage:
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier,
                                                     for: indexPath) as! MovieTableViewCell
            cell.setCell(image: URL(string: "https://image.tmdb.org/t/p/w500" + (popularMovies.value[indexPath.row].posterPath ?? "")),
                         title: popularMovies.value[indexPath.row].originalTitle ?? "",
                         description: popularMovies.value[indexPath.row].overview ?? "Description not found")
            cell.selectionStyle = .none
            return cell
        case .search:
            if indexPath.section == 0 || indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier,
                                                         for: indexPath) as! MovieTableViewCell
                cell.setCell(image: URL(string: "https://image.tmdb.org/t/p/w500" + (searchResults.value[indexPath.section][indexPath.row].posterPath ?? "")),
                             title: searchResults.value[indexPath.section][indexPath.row].name ?? searchResults.value[indexPath.section][indexPath.row].title ?? "",
                             description: searchResults.value[indexPath.section][indexPath.row].overview ?? "")
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: ActorTableViewCell.identifier,
                                                         for: indexPath) as! ActorTableViewCell
                cell.setCell(image: URL(string: "https://image.tmdb.org/t/p/w500" + (searchResults.value[indexPath.section][indexPath.row].profilePath ?? "")),
                             fullName: searchResults.value[indexPath.section][indexPath.row].name ?? "")
                cell.selectionStyle = .none
                return cell
            }
        }
    }

    func getSectionHeader(section: Int) -> TitleHeaderView {
        if section == 0 {
            return TitleHeaderView(title: "Tv-Series")
        } else if section == 1 {
            return TitleHeaderView(title: "Movie")
        } else {
            return TitleHeaderView(title: "Actor, Actress etc.")
        }
    }
    
    func getMovieID(indexPath: IndexPath) -> Int? {
        return popularMovies.value[indexPath.row].id
    }
    
}
