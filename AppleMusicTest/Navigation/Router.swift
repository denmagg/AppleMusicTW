//
//  Router.swift
//  AppleMusicTest
//
//  Created by Денис Медведев on 13.01.2023.
//

import UIKit

//базовый тип для всех роутеров
protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

//для конкретного роутера
protocol RouterProtocol: RouterMain {
    func initialViewController()
}

final class Router: RouterProtocol {
    
    //MARK: properties
    
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    //MARK: inits
    
    init(navigationController: UINavigationController?, assemblyBuilder: AssemblyBuilderProtocol?){
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    //MARK: methods
    
    func initialViewController() {
        guard let mainViewController = assemblyBuilder?.createMainModule(router: self) else { return }
        navigationController?.pushViewController(mainViewController, animated: true)
    }
    
}

