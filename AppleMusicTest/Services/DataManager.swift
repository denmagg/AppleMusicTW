//
//  FileManager.swift
//  AppleMusicTest
//
//  Created by Денис Медведев on 17.01.2023.
//

import Foundation

final class DataManager {
    
    static let shared = DataManager()
    
    private init() {}
    
    private func getJSONPath() throws -> URL {
        do {
            let filePath = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: .none, create: false).appendingPathComponent("PlayListDTO.json")
            return filePath
        } catch let error {
            throw error
        }
    }
    
    private func getImagePath(for url: URL) throws -> URL {
        do {
            let imageName = url.lastPathComponent
            let filePath = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: .none, create: true).appendingPathComponent(imageName)
            return filePath
        } catch let error {
            throw error
        }
    }
    
    func fetchJSONData() throws -> PlayListDTO {
        do {
            let filePath = try getJSONPath()
            let fileData = try Data(contentsOf: filePath)
            let data = try JSONDecoder().decode(PlayListDTO.self, from: fileData)
            return data
        } catch let error {
            throw error
        }
    }
    
    func saveJSONData(data: PlayListDTO) throws {
        do {
            let filePath = try getJSONPath()
            let data = try JSONEncoder().encode(data)
            try data.write(to: filePath)
            return
        } catch let error {
            throw error
        }
    }
    
    func saveImageData(data: Data, by url: URL) throws {
        do {
            let filePath = try getImagePath(for: url)
            try data.write(to: filePath)
        } catch let error {
            throw error
        }
    }
    
    func fetchImageData(from url: URL) throws -> Data {
        do {
            let filePath = try getImagePath(for: url)
            let data = try Data(contentsOf: filePath)
            return data
        } catch let error {
            throw error
        }
    }
    
    func deleteImageData(from url: URL) throws {
        do {
            let filePath = try getImagePath(for: url)
            try FileManager.default.removeItem(at: filePath)
        } catch let error {
            throw error
        }
    }
    
    func deleteAllData() {
        let fileManager = FileManager.default
        let documentsUrl =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first! as NSURL
        let documentsPath = documentsUrl.path
        
        do {
            if let documentPath = documentsPath
            {
                let fileNames = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                for fileName in fileNames {
                        let filePathName = "\(documentPath)/\(fileName)"
                        try fileManager.removeItem(atPath: filePathName)
                }
            }
            
        } catch let error {
            print(error)
        }
    }
}

