//
//  PokemonListPresenter.swift
//  TestPokemonTask
//
//  Created by Zenya Kirilov on 25.10.22.
//

import Foundation

protocol PokemonListViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
}

protocol PokemonListPresenterProtocol: AnyObject {
    init(view: PokemonListViewProtocol, networkService: NetworkDataFetchProtocol)
    func getPokemons()
    var pokemons: [Pokemon]? { get set }
}

class PokemonListPresenter: PokemonListPresenterProtocol {
    weak var view: PokemonListViewProtocol?
    let networkService: NetworkDataFetchProtocol!
    var pokemons: [Pokemon]?
    
    required init(view: PokemonListViewProtocol, networkService: NetworkDataFetchProtocol) {
        self.view = view
        self.networkService = networkService
        getPokemons()
    }
    
    func getPokemons() {
        networkService.fetchPokemons { [weak self] pokemonModel, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if error == nil {
                    guard let pokemonModel = pokemonModel else { return }
                    self.pokemons = pokemonModel.results
                    self.view?.success()
                } else {
                    self.view?.failure(error: error!)
                }
            }
        }
    }
}
