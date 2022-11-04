//
//  NetworkMonitor.swift
//  TestPokemonTask
//
//  Created by Zenya Kirilov on 26.10.22.
//

import Foundation
import Network

protocol NetworkMonitorProtocol {
    func startMonitoring()
    func stopMonitoring()
    var isReachable: Bool { get set }
}

extension Notification.Name {
    static let connectivityStatus = Notification.Name(rawValue: "connectivityStatusChanged")
}

class NetworkMonitor: NetworkMonitorProtocol {
    
    static let shared = NetworkMonitor()
    
    private init() {}

    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool = true
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            self.status = path.status
            self.isReachable = (path.status == .satisfied) ? true : false

            if path.status == .satisfied {
                Log.info("We're connected!")
            } else {
                Log.info("No connection.")
            }
            
            NotificationCenter.default.post(name: .connectivityStatus, object: nil)
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
