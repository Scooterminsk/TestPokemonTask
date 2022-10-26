//
//  ModuleBuilder.swift
//  TestPokemonTask
//
//  Created by Zenya Kirilov on 25.10.22.
//

import UIKit

protocol Builder {
    func createPokemonListModule() -> UIViewController
    func createDetailModule(pokemon: Pokemon?) -> UIViewController
}

class ModuleBuilder: Builder {
    func createPokemonListModule() -> UIViewController {
        let view = PokemonListViewController()
        let networkService = NetworkDataFetch.shared
        let presenter = PokemonListPresenter(view: view, networkService: networkService)
        view.presenter = presenter
        return view
    }
    
    func createDetailModule(pokemon: Pokemon?) -> UIViewController {
        let view = DetailViewController()
        let networkRequestService = NetworkRequest.shared
        let networkFetchService = NetworkDataFetch.shared
        let presenter = DetailPresenter(view: view, networkRequestService: networkRequestService, networkFetchService: networkFetchService, pokemon: pokemon)
        view.presenter = presenter
        return view
    }
}
