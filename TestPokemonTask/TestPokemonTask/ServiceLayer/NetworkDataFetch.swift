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

final class NetworkDataFetch: NetworkDataFetchProtocol {
    var networkRequestService: NetworkRequestProtocol
    
    init(networkRequestService: NetworkRequestProtocol) {
        self.networkRequestService = networkRequestService
    }
    
    func fetchPokemons(pagination: Bool = false, response: @escaping (PokemonModel?, Error?) -> Void) {
        
        let urlString = R.string.staticStrings.urlNoPagination()
        let urlStringPagination = R.string.staticStrings.urlPagination()
        
        networkRequestService.requestData(urlString: pagination == false ? urlString: urlStringPagination) { result in
            switch result {
            case .success(let data):
                do {
                    let pokemons = try JSONDecoder().decode(PokemonModel.self, from: data)
                    response(pokemons, nil)
                } catch let jsonError {
                    Log.error(R.string.staticStrings.jsonError() + jsonError.localizedDescription,
                              shouldLogContext: true)
                    response(nil, jsonError)
                }
            case .failure(let error):
                Log.error(R.string.staticStrings.dataFailureError() + error.localizedDescription,
                          shouldLogContext: true)
                response(nil, error)
            }
        }
    }
    
    func fetchPokemonDescription(urlString: String, response: @escaping (PokemonDescriptionModel?, Error?) -> Void) {
        
        networkRequestService.requestData(urlString: urlString) { result in
            switch result {
            case .success(let data):
                do {
                    let pokemonDescription = try JSONDecoder().decode(PokemonDescriptionModel.self, from: data)
                    response(pokemonDescription, nil)
                } catch let jsonError {
                    Log.error(R.string.staticStrings.jsonError() + jsonError.localizedDescription,
                              shouldLogContext: true)
                    response(nil, jsonError)
                }
            case .failure(let error):
                Log.error(R.string.staticStrings.dataFailureError() + error.localizedDescription,
                          shouldLogContext: true)
                response(nil, error)
            }
        }
    }

}
