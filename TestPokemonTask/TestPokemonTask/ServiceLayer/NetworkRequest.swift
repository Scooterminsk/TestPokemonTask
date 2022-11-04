//
//  NetworkRequest.swift
//  TestPokemonTask
//
//  Created by Zenya Kirilov on 25.10.22.
//

import Foundation

protocol NetworkRequestProtocol {
    func requestData(urlString: String, completion: @escaping (Result<Data, Error>) -> Void)
    init(urlSessionObject: URLSession)
}

class NetworkRequest: NetworkRequestProtocol {
    var urlSessionObject: URLSession?
    
    required init(urlSessionObject: URLSession) {
        self.urlSessionObject = urlSessionObject
    }
    
    func requestData(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = URL(string: urlString) else { return }
        guard let urlSessionObject = urlSessionObject else { return }
        
        urlSessionObject.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            completion(.success(data))
        }
        .resume()
    }
}
