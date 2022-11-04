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
        let presenter = MainPresenter(view: view,
                                      networkMonitor: networkMonitor,
                                      router: router)
        view.presenter = presenter
        return view
    }
    
    func createPokemonListModule(router: RouterProtocol) -> UIViewController {
        let view = PokemonListViewController()
        let urlSession = URLSession(configuration: .default)
        let networkRequestService = NetworkRequest(urlSessionObject: urlSession)
        let networkFetchService = NetworkDataFetch(networkRequestService: networkRequestService)
        let networkMonitor = NetworkMonitor.shared
        let dbManager = DBManager()
        let presenter = PokemonListPresenter(view: view,
                                             networkFetchService: networkFetchService,
                                             networkMonitor: networkMonitor,
                                             router: router,
                                             dbManager: dbManager)
        view.presenter = presenter
        return view
    }
    
    func createDetailModule(pokemon: Pokemon?, id: Int?, router: RouterProtocol) -> UIViewController {
        let view = DetailViewController()
        let urlSession = URLSession(configuration: .default)
        let networkRequestService = NetworkRequest(urlSessionObject: urlSession)
        let networkFetchService = NetworkDataFetch(networkRequestService: networkRequestService)
        let networkMonitor = NetworkMonitor.shared
        let dbManager = DBManager()
        let presenter = DetailPresenter(view: view,
                                        networkRequestService: networkRequestService,
                                        networkFetchService: networkFetchService,
                                        id: id,
                                        networkMonitor: networkMonitor,
                                        router: router,
                                        dbManager: dbManager,
                                        pokemon: pokemon)
        view.presenter = presenter
        return view
    }
}
