//
//  DetailPresenter.swift
//  TestPokemonTask
//
//  Created by Zenya Kirilov on 26.10.22.
//

import Foundation

protocol DetailViewProtocol: AnyObject {
    func setPokemon(pokemon: Pokemon?)
}

protocol DetailViewPresenterProtocol: AnyObject {
    init(view: DetailViewProtocol, networkService: NetworkDataFetchProtocol, pokemon: Pokemon?)
}

class DetailPresenter: DetailViewPresenterProtocol {
    weak var view: DetailViewProtocol?
    let networkService: NetworkDataFetchProtocol!
    var pokemon: Pokemon?
    
    required init(view: DetailViewProtocol, networkService: NetworkDataFetchProtocol, pokemon: Pokemon?) {
        self.view = view
        self.networkService = networkService
        self.pokemon = pokemon
    }
    
    public func setPokemon() {
        view?.setPokemon(pokemon: pokemon)
    }
}
