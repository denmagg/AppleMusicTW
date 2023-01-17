//
//  NetworkService.swift
//  AppleMusicTest
//
//  Created by Денис Медведев on 13.01.2023.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchPlaylist(complition: @escaping (Result<PlayListDTO, Error>) -> Void)
    func fetchImageData(from urlString: String, complition: @escaping (Result<Data, Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    
    private enum Consts {
        static let playlistUrlString = "http://test.iospro.ru/playlistdata.json"
    }
    
    func fetchPlaylist(complition: @escaping (Result<PlayListDTO, Error>) -> Void) {
        
        do {
            let obj = try DataManager.shared.fetchJSONData()
            complition(.success(obj))
        } catch {
            guard let playlistUrl = URL(string: Consts.playlistUrlString) else {
                print("Проверьте валидность URL адреса")
                return
            }
            
            let session = URLSession.shared
            session.dataTask(with: playlistUrl) { (data, _, error) in
                if let data = data, error == nil {
                    do {
                        let obj = try JSONDecoder().decode(PlayListDTO.self, from: data)
                        try DataManager.shared.saveJSONData(data: obj)
                        complition(.success(obj))
                    } catch let error {
                        complition(.failure(error))
                        return
                    }
                } else {
                    complition(.failure(error!))
                    return
                }
            }.resume()
        }
    }
    
    func fetchImageData(from urlString: String, complition: @escaping (Result<Data, Error>) -> Void) {

        guard let url = URL(string: urlString) else {
            print("Проверьте валидность URL адреса")
            return
        }
        do {
            let data = try DataManager.shared.fetchImageData(from: url)
            complition(.success(data))
        } catch {
            let session = URLSession.shared
            session.dataTask(with: url) { (data, _, error) in
                
                if let data = data, error == nil {
                    
                    do {
                        try DataManager.shared.saveImageData(data: data, by: url)
                        complition(.success(data))
                        return
                    } catch let error {
                        complition(.failure(error))
                    }
                } else {
                    complition(.failure(error!))
                    return
                }
            }.resume()
        }
    }
}
