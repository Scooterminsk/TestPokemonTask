//
//  AssemblyModuleBuilder.swift
//  TestPokemonTask
//
//  Created by Zenya Kirilov on 25.10.22.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController
    func createPokemonListModule(router: RouterProtocol) -> UIViewController
    func createDetailModule(pokemon: Pokemon?, id: Int?, router: RouterProtocol) -> UIViewController
}

class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    
    func createMainModule(router: RouterProtocol) -> UIViewController {
        let view = MainViewController()
        let networkMonitor = NetworkMonitor.shared
        let presenter = MainPresenter(view: view, networkMonitor: networkMonitor, router: router)
        view.presenter = presenter
        return view
    }
    
    func createPokemonListModule(router: RouterProtocol) -> UIViewController {
        let view = PokemonListViewController()
        let networkService = NetworkDataFetch.shared
        let dbManager = DBManager()
        let presenter = PokemonListPresenter(view: view, networkService: networkService, router: router, dbManager: dbManager)
        view.presenter = presenter
        return view
    }
    
    func createDetailModule(pokemon: Pokemon?, id: Int?, router: RouterProtocol) -> UIViewController {
        let view = DetailViewController()
        let networkRequestService = NetworkRequest.shared
        let networkFetchService = NetworkDataFetch.shared
        let dbManager = DBManager()
        let presenter = DetailPresenter(view: view,
                                        networkRequestService: networkRequestService,
                                        networkFetchService: networkFetchService,
                                        id: id,
                                        router: router,
                                        dbManager: dbManager,
                                        pokemon: pokemon)
        view.presenter = presenter
        return view
    }
}
