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
    func setPokemonImage(imageData: Data?)
}

protocol DetailViewPresenterProtocol: AnyObject {
    init(view: DetailViewProtocol,
         networkRequestService: NetworkRequestProtocol,
         networkFetchService: NetworkDataFetchProtocol,
         router: RouterProtocol,
         pokemon: Pokemon?)
    
    func getPokemonDescription()
    var pokemon: Pokemon? { get set }
    var pokemonDescription: PokemonDescriptionModel? { get set }
}

class DetailPresenter: DetailViewPresenterProtocol {
    weak var view: DetailViewProtocol?
    let networkRequestService: NetworkRequestProtocol!
    let networkFetchService: NetworkDataFetchProtocol!
    var router: RouterProtocol?
    var pokemon: Pokemon?
    var pokemonDescription: PokemonDescriptionModel?
    
    required init(view: DetailViewProtocol,
                  networkRequestService: NetworkRequestProtocol,
                  networkFetchService: NetworkDataFetchProtocol,
                  router: RouterProtocol,
                  pokemon: Pokemon?) {
        self.view = view
        self.networkRequestService = networkRequestService
        self.networkFetchService = networkFetchService
        self.router = router
        self.pokemon = pokemon
    }
    
    public func getPokemonDescription() {
        networkFetchService.fetchPokemonDescription(urlString: pokemon?.url ?? "") { [weak self] pokemonDescriptionModel, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if error == nil {
                    guard let pokemonDescriptionModel = pokemonDescriptionModel else { return }
                    self.pokemonDescription = pokemonDescriptionModel
                    self.getPokemonImage(urlString: pokemonDescriptionModel.sprites.other?.home.front_default)
                    self.view?.pokemonDescriptionSuccess()
                } else {
                    self.view?.pokemonDescriptionFailure(error: error!)
                }
            }
        }
    }
    
    private func getPokemonImage(urlString: String?) {
        guard let urlString = urlString else { return }
        networkRequestService.requestData(urlString: urlString) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.view?.setPokemonImage(imageData: data)
            case .failure(let error):
                print("Error occured while trying to get a pokemon image", error.localizedDescription)
            }
        }
    }
}
