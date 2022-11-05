//
//  MainPresenterTest.swift
//  TestPokemonTaskTests
//
//  Created by Zenya Kirilov on 5.11.22.
//

import XCTest
@testable import TestPokemonTask

class ViewSpy: MainViewProtocol {
    
    var didOnlineModeCalled = false
    var didOfflineModeCalled = false
    var didAlertShowed = false
    
    func alertNoNetworkAndCache() {
        didAlertShowed = true
    }
    
    func onlineMode() {
        didOnlineModeCalled = true
    }
    
    func offlineMode() {
        didOfflineModeCalled = true
    }
}

class NetworkMonitorSpy: NetworkMonitorProtocol {

    var isConnectedCalled = false
    var isMonitoringStarted = false

    var isConnected: Bool {
        NotificationCenter.default.post(name: .connectivityStatus, object: nil)
        isConnectedCalled = true
        return true
    }

    func startMonitoring() {
        isMonitoringStarted = true
    }

    func stopMonitoring() {}
}

class NetworkMonitorNotConnectedDummy: NetworkMonitorProtocol {
    func startMonitoring() {}
    func stopMonitoring() {}
    
    var isConnected: Bool {
        NotificationCenter.default.post(name: .connectivityStatus, object: nil)
        return false
    }
}

final class MainPresenterTest: XCTestCase {
    
    var presenter: MainPresenter!
    var router: RouterProtocol!

    override func setUpWithError() throws {
      let navigationVC = UINavigationController()
        let assembly = AssemblyModuleBuilder()
        router = Router(navigationController: navigationVC, assemblyBuilder: assembly)
    }

    override func tearDownWithError() throws {
        router = nil
        presenter = nil
    }

    func testStartCheckingConnection() throws {
        let view = ViewSpy()
        let networkMonitor = NetworkMonitorSpy()
        
        presenter = MainPresenter(view: view, networkMonitor: networkMonitor, router: router)
        
        presenter.startCheckingConnection()
        
        XCTAssertTrue(networkMonitor.isMonitoringStarted)
    }
    
    func testOnlineModeCalled() throws {
        let view = ViewSpy()
        let networkMonitor = NetworkMonitorSpy()
        
        presenter = MainPresenter(view: view, networkMonitor: networkMonitor, router: router)
        
        presenter.addNetworkObserver()
        
        XCTAssertTrue(view.didOnlineModeCalled)
        
    }


}
