//
//  MainPresenterProtocol.swift
//  AppleMusicTest
//
//  Created by Денис Медведев on 13.01.2023.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
    init(view: MainViewProtocol, router: RouterProtocol, networkService: NetworkServiceProtocol)
    func fetchPlaylist()
    func getAlbum(for indexPath: IndexPath) -> Album?
    func getNumberOfRows() -> Int?
    func setFilter(filter: String)
    func fetchImageData(for indexPath: IndexPath, completion: @escaping (Data?) -> Void)
    func updateAlbumTitle(with imageUrl: String, on newTitle: String?)
    func didTapHideAlbum(at indexPath: IndexPath)
    func didTapEditAlbum(at indexPath: IndexPath)
}

