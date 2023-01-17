//
//  MainViewModel.swift
//  AppleMusicTest
//
//  Created by Денис Медведев on 13.01.2023.
//

import Foundation

final class MainPresenter {
    
    //MARK: Private properties
    
    private weak var view: MainViewProtocol?
    private var router: RouterProtocol?
    private var networkService: NetworkServiceProtocol?
    private var filter = "" {
        didSet {
            if filter != "" {
                filteredAmbums = albums?.filter({ album in
                    album.title.lowercased().contains(filter.lowercased()) || album.subtitle.lowercased().contains(filter.lowercased())
                })
            } else {
                filteredAmbums = albums
            }
        }
    }
    private var albums: [Album]? {
        didSet {
            if filter != "" {
                filteredAmbums = albums?.filter({ album in
                    album.title.lowercased().contains(filter.lowercased()) || album.subtitle.lowercased().contains(filter.lowercased())
                })
            } else {
                filteredAmbums = albums
            }
        }
    }
    private var filteredAmbums: [Album]?
    
    //MARK: Init
    
    required init(view: MainViewProtocol, router: RouterProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.router = router
        self.networkService = networkService
        fetchPlaylist()
    }
    
}

//MARK: MainPresenterProtocol

extension MainPresenter: MainPresenterProtocol {
    
    func getNumberOfRows() -> Int? {
        guard let model = filteredAmbums else { return nil }
        return model.count
    }
    
    func getAlbum(for indexPath: IndexPath) -> Album? {
        guard let model = filteredAmbums else { return nil }
        return model[indexPath.row]
    }
    
    func fetchImageData(for indexPath: IndexPath, completion: @escaping (Data?) -> Void) {
        guard let urlString = filteredAmbums?[indexPath.row].image else { return }
                
        networkService?.fetchImageData(from: urlString, complition: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let imageData):
                    completion(imageData)
                case .failure(_):
                    break
                }
            }
        })
    }
    
    func setFilter(filter: String) {
        self.filter = filter
        view?.updateTableView()
    }
    
    func fetchPlaylist() {
        networkService?.fetchPlaylist { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let playlist):
                    self?.albums = playlist.albums
                    self?.view?.updateTableView()
                case .failure(let error):
                    self?.view?.showAlert(title: "", message: error.localizedDescription)
                }
            }
        }
    }
    
    func updateAlbumTitle(with imageUrl: String, on newTitle: String?) {
        let index = albums?.firstIndex{ $0.image == imageUrl }
        guard let index = index else { return }
        if newTitle != nil && newTitle?.trimmingCharacters(in: .whitespaces) != "" {
            do {
                albums?[index].title = newTitle!
                try DataManager.shared.saveJSONData(data: PlayListDTO(albums: albums))
                view?.updateTableView()
            } catch let error {
                view?.showAlert(title: "", message: error.localizedDescription)
            }
        }
    }
    
    func didTapHideAlbum(with imageUrl: String) {
        let index = albums?.firstIndex { $0.image == imageUrl }
        guard let index = index else { return }
        albums?.remove(at: index)
        view?.updateTableView()
    }
    
    func didTapEditAlbum(at indexPath: IndexPath) {
        if let album = getAlbum(for: indexPath) {
            view?.showAlbumEditingMenu(album: album)
        }
    }
    
    func didTapHideAlbum(at indexPath: IndexPath) {
        if let album = getAlbum(for: indexPath) {
            let index = albums?.firstIndex { $0.image == album.image }
            guard let index = index, let deletedImage = albums?.remove(at: index).image else { return }
            do {
                guard let url = URL(string: deletedImage) else {
                    print("Проверьте правильность url картинки \(deletedImage)")
                    return
                }
                try DataManager.shared.deleteImageData(from: url)
                try DataManager.shared.saveJSONData(data: PlayListDTO(albums: albums))
            } catch let error {
                view?.showAlert(title: "", message: error.localizedDescription)
            }
            view?.updateTableView()
        }
    }
    
}
