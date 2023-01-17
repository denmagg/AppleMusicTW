//
//  AssemblyBuilder.swift
//  AppleMusicTest
//
//  Created by Денис Медведев on 13.01.2023.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController
}

final class AssemblyBuilder: AssemblyBuilderProtocol {
    
    //MARK: methods
    
    func createMainModule(router: RouterProtocol) -> UIViewController {
        let view = MainViewController()
        let networkService = NetworkService()
        let presenter = MainPresenter(view: view, router: router, networkService: networkService)
        view.presenter = presenter
        return view
    }
    
}

