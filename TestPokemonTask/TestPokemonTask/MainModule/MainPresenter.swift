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
    func addNetworkObserver()
    func removeNetworkObserver()
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
    
    func addNetworkObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(showOfflineDeviceUI(notification:)), name: NSNotification.Name.connectivityStatus, object: nil)
    }
    
    @objc func showOfflineDeviceUI(notification: Notification) {
        if networkMonitor.isConnected {
            Log.info("Connected.")
            DispatchQueue.main.async {
                self.view?.onlineMode()
            }
            return
        } else {
            Log.info("Not connected.")
            DispatchQueue.main.async {
                self.view?.alertNoNetworkAndCache()
                self.view?.offlineMode()
            }
        }
    }
    
    func removeNetworkObserver() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.connectivityStatus, object: nil)
    }
}

