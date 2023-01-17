//
//  MainViewProtocol.swift
//  AppleMusicTest
//
//  Created by Денис Медведев on 13.01.2023.
//

import Foundation

protocol MainViewProtocol: AnyObject {
    func updateTableView()
    func showAlert(title: String, message: String)
    func showAlbumEditingMenu(album: Album)
}
