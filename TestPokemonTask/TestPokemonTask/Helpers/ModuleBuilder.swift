//
//  ModuleBuilder.swift
//  TestPokemonTask
//
//  Created by Zenya Kirilov on 25.10.22.
//

import UIKit

protocol Builder {
    func createPokemonListModule() -> UIViewController
}

class ModuleBuilder: Builder {
    func createPokemonListModule() -> UIViewController {
        let view = PokemonListViewController()
        let networkService = NetworkDataFetch.shared
        let presenter = PokemonListPresenter(view: view, networkService: networkService)
        view.presenter = presenter
        return view
    }
}
