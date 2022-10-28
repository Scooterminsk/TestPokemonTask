//
//  MainPresenter.swift
//  TestPokemonTask
//
//  Created by Zenya Kirilov on 27.10.22.
//

import Foundation
import Network

protocol MainViewProtocol: AnyObject {
    func alertNoNetworkAndCache()
    func onlineMode()
    func offlineMode()
}

protocol MainPresenterProtocol: AnyObject {
    init(view: MainViewProtocol, networkMonitor: NetworkMonitorProtocol, router: RouterProtocol)
    func toPokemons()
    func startCheckingConnection()
    func checkNetworkStatus()
}

class MainPresenter: MainPresenterProtocol {
    weak var view: MainViewProtocol?
    let networkMonitor: NetworkMonitorProtocol!
    var router: RouterProtocol?
    
    required init(view: MainViewProtocol, networkMonitor: NetworkMonitorProtocol, router: RouterProtocol) {
        self.view = view
        self.networkMonitor = networkMonitor
        self.router = router
    }
    
    func toPokemons() {
        router?.showPokemonsList()
    }
    
    func startCheckingConnection() {
        networkMonitor.startMonitoring()
    }
    
    func checkNetworkStatus() {
        if networkMonitor.isReachable == false {
            view?.alertNoNetworkAndCache()
            view?.offlineMode()
        } else {
            view?.onlineMode()
        }
    }
}

