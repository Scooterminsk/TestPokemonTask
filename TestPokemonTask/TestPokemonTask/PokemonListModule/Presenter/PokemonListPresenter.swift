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
    init(view: PokemonListViewProtocol, networkService: NetworkDataFetchProtocol, router: RouterProtocol, dbManager: DBManagerProtocol)
    func getPokemons()
    var pokemons: [Pokemon]? { get set }
    func tapOnPokemonsName(pokemon: Pokemon?, id: Int?)
    func getPokemonsPagination()
}

class PokemonListPresenter: PokemonListPresenterProtocol {
    weak var view: PokemonListViewProtocol?
    let networkService: NetworkDataFetchProtocol!
    var router: RouterProtocol?
    var pokemons: [Pokemon]?
    var dbManager: DBManagerProtocol?
    
    required init(view: PokemonListViewProtocol, networkService: NetworkDataFetchProtocol, router: RouterProtocol, dbManager: DBManagerProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
        self.dbManager = dbManager
        getPokemons()
    }
    
    func tapOnPokemonsName(pokemon: Pokemon?, id: Int?) {
        guard let pokemon = pokemon else { return }
        router?.showDetails(pokemon: pokemon, id: id)
    }
    
    func getPokemons() {
        let pokemonsRealm = dbManager?.obtainPokemons()
        if pokemonsRealm!.count > 0 {
            var allPokemons = [Pokemon]()
            for pokemon in pokemonsRealm! {
                let currentPokemon = Pokemon(name: pokemon.name, url: pokemon.url)
                allPokemons.append(currentPokemon)
            }
            self.pokemons = allPokemons
            self.view?.success()
            return
        } else {
            getPokemonsFromAPI()
        }
    }
    
    private func getPokemonsFromAPI() {
        networkService.fetchPokemons(pagination: false) { [weak self] pokemonModel, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if error == nil {
                    guard let pokemonModel = pokemonModel else { return }
                    self.pokemons = pokemonModel.results
                    self.savePokemonsRealm(pokemons: pokemonModel.results, startIndex: 0)
                    self.view?.success()
                } else {
                    self.view?.failure(error: error!)
                }
            }
        }
    }
    
    private func savePokemonsRealm(pokemons: [Pokemon], startIndex: Int) {
        var index = startIndex
        for pokemon in pokemons {
            let pokemonRealm = PokemonModelRealm()
            pokemonRealm.name = pokemon.name
            pokemonRealm.url = pokemon.url
            pokemonRealm.id = index
            dbManager?.save(pokemonModel: pokemonRealm)
            index += 1
        }
    }
    
    func getPokemonsPagination() {
        networkService.fetchPokemons(pagination: true) { [weak self] pokemonModel, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if error == nil {
                    guard let pokemonModel = pokemonModel else { return }
                    self.pokemons?.append(contentsOf: pokemonModel.results)
                    self.savePokemonsRealm(pokemons: pokemonModel.results, startIndex: 10)
                    self.view?.success()
                } else {
                    self.view?.failure(error: error!)
                }
            }
        }
    }
}
