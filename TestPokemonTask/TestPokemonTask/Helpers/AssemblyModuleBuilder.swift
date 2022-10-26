//
//  AssemblyModuleBuilder.swift
//  TestPokemonTask
//
//  Created by Zenya Kirilov on 25.10.22.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createPokemonListModule(router: RouterProtocol) -> UIViewController
    func createDetailModule(pokemon: Pokemon?, router: RouterProtocol) -> UIViewController
}

class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    func createPokemonListModule(router: RouterProtocol) -> UIViewController {
        let view = PokemonListViewController()
        let networkService = NetworkDataFetch.shared
        let presenter = PokemonListPresenter(view: view, networkService: networkService, router: router)
        view.presenter = presenter
        return view
    }
    
    func createDetailModule(pokemon: Pokemon?, router: RouterProtocol) -> UIViewController {
        let view = DetailViewController()
        let networkRequestService = NetworkRequest.shared
        let networkFetchService = NetworkDataFetch.shared
        let presenter = DetailPresenter(view: view,
                                        networkRequestService: networkRequestService,
                                        networkFetchService: networkFetchService,
                                        router: router,
                                        pokemon: pokemon)
        view.presenter = presenter
        return view
    }
}
