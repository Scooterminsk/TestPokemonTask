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
    init(view: PokemonListViewProtocol, networkService: NetworkDataFetchProtocol, router: RouterProtocol)
    func getPokemons()
    var pokemons: [Pokemon]? { get set }
    func tapOnPokemonsName(pokemon: Pokemon?)
}

class PokemonListPresenter: PokemonListPresenterProtocol {
    weak var view: PokemonListViewProtocol?
    let networkService: NetworkDataFetchProtocol!
    var router: RouterProtocol?
    var pokemons: [Pokemon]?
    
    required init(view: PokemonListViewProtocol, networkService: NetworkDataFetchProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
        getPokemons()
    }
    
    func tapOnPokemonsName(pokemon: Pokemon?) {
        guard let pokemon = pokemon else { return }
        router?.showDetails(pokemon: pokemon)
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
