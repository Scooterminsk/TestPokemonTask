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
    init(view: PokemonListViewProtocol,
         networkFetchService: NetworkDataFetchProtocol,
         networkMonitor: NetworkMonitorProtocol,
         router: RouterProtocol,
         dbManager: DBManagerProtocol)
    func getPokemons()
    var pokemons: [Pokemon]? { get set }
    func tapOnPokemonsName(pokemon: Pokemon?, id: Int?)
    func getPokemonsPagination()
    func getPokemonsFromAPI()
    func savePokemonsRealm(pokemons: [Pokemon], startIndex: Int)
}

final class PokemonListPresenter: PokemonListPresenterProtocol {
    weak var view: PokemonListViewProtocol?
    let networkFetchService: NetworkDataFetchProtocol
    let networkMonitor: NetworkMonitorProtocol
    var router: RouterProtocol
    var pokemons: [Pokemon]?
    var dbManager: DBManagerProtocol
    
    required init(view: PokemonListViewProtocol,
                  networkFetchService: NetworkDataFetchProtocol,
                  networkMonitor: NetworkMonitorProtocol,
                  router: RouterProtocol,
                  dbManager: DBManagerProtocol) {
        self.view = view
        self.networkFetchService = networkFetchService
        self.networkMonitor = networkMonitor
        self.router = router
        self.dbManager = dbManager
        getPokemons()
    }
    
    func tapOnPokemonsName(pokemon: Pokemon?, id: Int?) {
        guard let pokemon = pokemon else { return }
        router.showDetails(pokemon: pokemon, id: id)
    }
    
    func getPokemons() {
        let pokemonsRealm = dbManager.obtainPokemons()
        if networkMonitor.isConnected {
            getPokemonsFromAPI()
        } else if (pokemonsRealm).count > 0 {
            var allPokemons = [Pokemon]()
            for pokemon in pokemonsRealm {
                let currentPokemon = Pokemon(name: pokemon.name, url: pokemon.url)
                allPokemons.append(currentPokemon)
            }
            self.pokemons = allPokemons
            self.view?.success()
        }
    }
    
    func getPokemonsFromAPI() {
        networkFetchService.fetchPokemons(pagination: false) { [weak self] pokemonModel, error in
            guard let self = self else { return }
            if error == nil {
                guard let pokemonModel = pokemonModel else { return }
                self.pokemons = pokemonModel.results
                DispatchQueue.main.async {
                    self.savePokemonsRealm(pokemons: pokemonModel.results, startIndex: 0)
                    self.view?.success()
                }
            } else {
                guard let error = error else { return }
                self.view?.failure(error: error)
            }
        }
    }
    
    func savePokemonsRealm(pokemons: [Pokemon], startIndex: Int) {
        var index = startIndex
        for pokemon in pokemons {
            let pokemonRealm = PokemonModelRealm()
            pokemonRealm.name = pokemon.name
            pokemonRealm.url = pokemon.url
            pokemonRealm.id = index
            dbManager.save(pokemonModel: pokemonRealm)
            index += 1
        }
    }
    
    func getPokemonsPagination() {
        networkFetchService.fetchPokemons(pagination: true) { [weak self] pokemonModel, error in
            guard let self = self else { return }
            if error == nil {
                guard let pokemonModel = pokemonModel else { return }
                self.pokemons?.append(contentsOf: pokemonModel.results)
                DispatchQueue.main.async {
                    self.savePokemonsRealm(pokemons: pokemonModel.results, startIndex: 10)
                    self.view?.success()
                }
            } else {
                guard let error = error else { return }
                self.view?.failure(error: error)
            }
        }
    }
}
