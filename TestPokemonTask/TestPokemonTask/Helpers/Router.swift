//
//  Router.swift
//  TestPokemonTask
//
//  Created by Zenya Kirilov on 26.10.22.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func showDetails(pokemon: Pokemon)
}

class Router: RouterProtocol {
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialViewController() {
        if let navigationController = navigationController {
            guard let pokemonListViewController = assemblyBuilder?.createPokemonListModule(router: self) else { return }
            navigationController.viewControllers = [pokemonListViewController]
        }
    }

    func showDetails(pokemon: Pokemon) {
        if let navigationController = navigationController {
            guard let detailViewController = assemblyBuilder?.createDetailModule(pokemon: pokemon, router: self ) else { return }
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }
}
