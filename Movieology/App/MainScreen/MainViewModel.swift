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

    func getPopularMovies(isNextPage: Bool = false) {
        if isNextPage && currentPage <= maxPage {
            currentPage += 1
            WebService.shared.request(type: .popularMovies, page: currentPage, successHandler: handlePopularMovies(_:), errorHandler: handleError(_:))
        } else {
            currentPage = 1
            WebService.shared.request(type: .popularMovies,
                                      successHandler: handlePopularMovies(_:),
                                      errorHandler: handleError(_:))
        }
    }

    func search(text: String) {

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

    private func handleError(_ _error: customErrors) {
        error.value = _error
    }

    func getRowCount(screenState: MainScreenState) -> Int {
        switch screenState {
        case .popularMovies:
            return popularMovies.value.count
        case .nextPage:
            return popularMovies.value.count
        case .search:
            return 0
        }
    }

    func getSectionCount(screenState: MainScreenState) {

    }

    func getCell(tableView: UITableView, indexPath: IndexPath, screenState: MainScreenState) -> UITableViewCell {
        switch screenState {
        case .popularMovies:
            let cell = tableView.dequeueReusableCell(withIdentifier: MainScreenTableViewCell.identifier, for: indexPath) as! MainScreenTableViewCell
            cell.setCell(image: URL(string: "https://image.tmdb.org/t/p/w500" + (popularMovies.value[indexPath.row].posterPath ?? "")),
                         title: popularMovies.value[indexPath.row].originalTitle ?? "",
                         description: popularMovies.value[indexPath.row].overview ?? "")
            cell.selectionStyle = .none
            return cell
        case .nextPage:
            let cell = tableView.dequeueReusableCell(withIdentifier: MainScreenTableViewCell.identifier, for: indexPath) as! MainScreenTableViewCell
            cell.setCell(image: URL(string: "https://image.tmdb.org/t/p/w500" + (popularMovies.value[indexPath.row].posterPath ?? "")),
                         title: popularMovies.value[indexPath.row].originalTitle ?? "",
                         description: popularMovies.value[indexPath.row].overview ?? "Description not found")
            cell.selectionStyle = .none
            return cell
        case .search:
            return UITableViewCell()
        }
    }

}
