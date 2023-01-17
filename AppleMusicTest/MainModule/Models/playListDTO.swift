//
//  playListDTO.swift
//  AppleMusicTest
//
//  Created by Денис Медведев on 13.01.2023.
//

import Foundation

struct PlayListDTO: Codable {
    let albums: [Album]?
}

struct Album: Codable {
    var title: String
    let subtitle: String
    let image: String
}

