//
//  NetworkDataFetch.swift
//  TestPokemonTask
//
//  Created by Zenya Kirilov on 25.10.22.
//

import Foundation

protocol NetworkDataFetchProtocol {
    func fetchPokemons(pagination: Bool, response: @escaping (PokemonModel?, Error?) -> Void)
    func fetchPokemonDescription(urlString: String, response: @escaping (PokemonDescriptionModel?, Error?) -> Void)
}

class NetworkDataFetch: NetworkDataFetchProtocol {
    
    static let shared = NetworkDataFetch()
    
    private init() {}
    
    func fetchPokemons(pagination: Bool = false, response: @escaping (PokemonModel?, Error?) -> Void) {
        
        let urlString = "https://pokeapi.co/api/v2/pokemon?offset=0&limit=10"
        let urlStringPagination = "https://pokeapi.co/api/v2/pokemon?offset=10&limit=20"
        
        NetworkRequest.shared.requestData(urlString: pagination == false ? urlString: urlStringPagination) { result in
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
