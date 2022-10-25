//
//  NetworkDataFetch.swift
//  TestPokemonTask
//
//  Created by Zenya Kirilov on 25.10.22.
//

import Foundation

protocol NetworkDataFetchProtocol {
    func fetchPokemons(response: @escaping (PokemonModel?, Error?) -> Void)
    func fetchPokemonDescription(urlString: String, response: @escaping (PokemonDescriptionModel?, Error?) -> Void)
}

class NetworkDataFetch: NetworkDataFetchProtocol {
    
    static let shared = NetworkDataFetch()
    
    private init() {}
    
    func fetchPokemons(response: @escaping (PokemonModel?, Error?) -> Void) {
        
        let urlString = "https://pokeapi.co/api/v2/pokemon"
        
        NetworkRequest.shared.requestData(urlString: urlString) { result in
            switch result {
            case .success(let data):
                do {
                    let pokemons = try JSONDecoder().decode(PokemonModel.self, from: data)
                    response(pokemons, nil)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil, error)
            }
        }
    }
    
    func fetchPokemonDescription(urlString: String, response: @escaping (PokemonDescriptionModel?, Error?) -> Void) {
        
        NetworkRequest.shared.requestData(urlString: urlString) { result in
            switch result {
            case .success(let data):
                do {
                    let pokemonDescription = try JSONDecoder().decode(PokemonDescriptionModel.self, from: data)
                    response(pokemonDescription, nil)
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
