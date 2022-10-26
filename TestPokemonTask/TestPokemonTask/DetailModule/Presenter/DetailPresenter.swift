//
//  DetailPresenter.swift
//  TestPokemonTask
//
//  Created by Zenya Kirilov on 26.10.22.
//

import Foundation

protocol DetailViewProtocol: AnyObject {
    func pokemonDescriptionSuccess()
    func pokemonDescriptionFailure(error: Error)
}

protocol DetailViewPresenterProtocol: AnyObject {
    init(view: DetailViewProtocol, networkService: NetworkDataFetchProtocol, pokemon: Pokemon?)
    func getPokemonDescription()
    var pokemon: Pokemon? { get set }
    var pokemonDescription: PokemonDescriptionModel? { get set }
}

class DetailPresenter: DetailViewPresenterProtocol {
    weak var view: DetailViewProtocol?
    let networkService: NetworkDataFetchProtocol!
    var pokemon: Pokemon?
    var pokemonDescription: PokemonDescriptionModel?
    
    required init(view: DetailViewProtocol, networkService: NetworkDataFetchProtocol, pokemon: Pokemon?) {
        self.view = view
        self.networkService = networkService
        self.pokemon = pokemon
    }
    
    public func getPokemonDescription() {
        networkService.fetchPokemonDescription(urlString: pokemon?.url ?? "") { [weak self] pokemonDescriptionModel, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if error == nil {
                    guard let pokemonDescriptionModel = pokemonDescriptionModel else { return }
                    self.pokemonDescription = pokemonDescriptionModel
                    self.view?.pokemonDescriptionSuccess()
                } else {
                    self.view?.pokemonDescriptionFailure(error: error!)
                }
            }
        }
    }
}
