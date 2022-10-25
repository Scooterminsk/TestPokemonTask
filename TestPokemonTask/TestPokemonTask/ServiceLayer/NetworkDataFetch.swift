//
//  NetworkDataFetch.swift
//  TestPokemonTask
//
//  Created by Zenya Kirilov on 25.10.22.
//

import Foundation

class NetworkDataFetch {
    
    static let shared = NetworkDataFetch()
    
    private init() {}
    
    func fetchPokemons(urlString: String, response: @escaping (PokemonModel?, Error?) -> Void) {
        
        NetworkRequest.shared.requestData(urlString: urlString) { result in
            switch result {
            case .success(let data):
                do {
                    let pokemons = try JSONDecoder().decode(PokemonModel.self, from: data)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil, error)
            }
        }
    }
}
