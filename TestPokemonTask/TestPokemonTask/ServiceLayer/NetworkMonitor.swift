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
    var isConnected: Bool { get }
}

extension Notification.Name {
    static let connectivityStatus = Notification.Name(rawValue: "connectivityStatusChanged")
}

final class NetworkMonitor: NetworkMonitorProtocol {
    
    static let shared = NetworkMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private let monitor: NWPathMonitor
    
    private(set) var isConnected = false
    private(set) var isExpensive = false
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            self.isConnected = path.status != .unsatisfied
            self.isExpensive = path.isExpensive
            
            NotificationCenter.default.post(name: .connectivityStatus, object: nil)
        }

        
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
