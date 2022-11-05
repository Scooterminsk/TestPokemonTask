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
    
    func testshowOfflineDeviceUI_didOnlineModeCalled() throws {
        let view = ViewSpy()
        let networkMonitor = NetworkMonitorSpy()
        let expectation = expectation(forNotification: .connectivityStatus,
                                      object: nil,
                                      handler: nil)
        
        presenter = MainPresenter(view: view, networkMonitor: networkMonitor, router: router)
        
        presenter.showOfflineDeviceUI(notification: Notification(name: .connectivityStatus))
            
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            expectation.fulfill()
        }
            
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(view.didOnlineModeCalled)
        
    }

    func testshowOfflineDeviceUI_didOfflineModeCalled() throws {
        let view = ViewSpy()
        let networkMonitor = NetworkMonitorNotConnectedDummy()
        let expectation = expectation(forNotification: .connectivityStatus,
                                      object: nil,
                                      handler: nil)
        
        presenter = MainPresenter(view: view, networkMonitor: networkMonitor, router: router)
        
        presenter.showOfflineDeviceUI(notification: Notification(name: .connectivityStatus))
            
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            expectation.fulfill()
        }
            
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(view.didOfflineModeCalled)
        
    }

}
