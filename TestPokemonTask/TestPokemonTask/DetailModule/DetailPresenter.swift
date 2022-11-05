//
//  DetailPresenter.swift
//  TestPokemonTask
//
//  Created by Zenya Kirilov on 26.10.22.
//

import Foundation

protocol DetailViewProtocol: AnyObject {
    func pokemonDescriptionSuccess()
    func pokemonDescriptionSuccessRealm(name: String, height: Int, weight: Int, types: String)
    func pokemonDescriptionFailure(error: Error)
    func setPokemonImage(imageData: Data?)
}

protocol DetailViewPresenterProtocol: AnyObject {
    init(view: DetailViewProtocol,
         networkRequestService: NetworkRequestProtocol,
         networkFetchService: NetworkDataFetchProtocol,
         id: Int?,
         networkMonitor: NetworkMonitorProtocol,
         router: RouterProtocol,
         dbManager: DBManagerProtocol,
         pokemon: Pokemon?)
    
    func getPokemonDescription()
    var pokemon: Pokemon? { get set }
    var dbManager: DBManagerProtocol? { get set }
    var id: Int? { get set }
    var pokemonDescription: PokemonDescriptionModel? { get set }
}

final class DetailPresenter: DetailViewPresenterProtocol {
    weak var view: DetailViewProtocol?
    let networkRequestService: NetworkRequestProtocol!
    let networkFetchService: NetworkDataFetchProtocol!
    let networkMonitor: NetworkMonitorProtocol!
    var router: RouterProtocol?
    var dbManager: DBManagerProtocol?
    var pokemon: Pokemon?
    var id: Int?
    var pokemonDescription: PokemonDescriptionModel?
    
    required init(view: DetailViewProtocol,
                  networkRequestService: NetworkRequestProtocol,
                  networkFetchService: NetworkDataFetchProtocol,
                  id: Int?,
                  networkMonitor: NetworkMonitorProtocol,
                  router: RouterProtocol,
                  dbManager: DBManagerProtocol,
                  pokemon: Pokemon?) {
        self.view = view
        self.networkRequestService = networkRequestService
        self.networkFetchService = networkFetchService
        self.id = id
        self.dbManager = dbManager
        self.networkMonitor = networkMonitor
        self.router = router
        self.pokemon = pokemon
    }
    
    public func getPokemonDescription() {
        if networkMonitor.isConnected {
            getPokemonDescriptionFromAPI()
        } else if let id = id {
            let pokemonDescriptionRealm = dbManager?.obtainPokemonDescription(primaryKey: id)
            if let pokemonDescriptionRealm = pokemonDescriptionRealm {
                view?.pokemonDescriptionSuccessRealm(name: pokemonDescriptionRealm.name,
                                                     height: pokemonDescriptionRealm.height,
                                                     weight: pokemonDescriptionRealm.weight,
                                                     types: pokemonDescriptionRealm.types)
                view?.setPokemonImage(imageData: pokemonDescriptionRealm.image)
            }
        }
    }
    
    private func getPokemonDescriptionFromAPI() {
        networkFetchService.fetchPokemonDescription(urlString: pokemon?.url ?? "") { [weak self] pokemonDescriptionModel, error in
            guard let self = self else { return }
            if error == nil {
                guard let pokemonDescriptionModel = pokemonDescriptionModel else { return }
                self.pokemonDescription = pokemonDescriptionModel
                DispatchQueue.main.async {
                    self.savePokemonDescriptionRealm(pokemon: pokemonDescriptionModel, id: self.id)
                    self.getPokemonImage(urlString: pokemonDescriptionModel.sprites.other?.home.front_default)
                    Log.info("Pokemon description SAVED")
                    self.view?.pokemonDescriptionSuccess()
                }
            } else {
                guard let error = error else { return }
                self.view?.pokemonDescriptionFailure(error: error)
            }
        }
    }
    
    private func getPokemonImage(urlString: String?) {
        guard let urlString = urlString else { return }
        networkRequestService.requestData(urlString: urlString) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.view?.setPokemonImage(imageData: data)
                }
            case .failure(let error):
                Log.error("Error occured while trying to get a pokemon image: \(error.localizedDescription)",
                          shouldLogContext: true)
            }
        }
    }
    
    private func savePokemonDescriptionRealm(pokemon: PokemonDescriptionModel?, id: Int?) {
        guard let pokemon = pokemon,
              let id = id else { return }
        let pokemonDescriptionRealm = PokemonDescriptionModelRealm()
        pokemonDescriptionRealm.id = id
        pokemonDescriptionRealm.height = pokemon.height
        pokemonDescriptionRealm.name = pokemon.name
        pokemonDescriptionRealm.types = pokemon.types.map{$0.type.name.capitalized}.joined(separator: ", ")
        pokemonDescriptionRealm.weight = pokemon.weight
        dbManager?.save(pokemonDescriptionModel: pokemonDescriptionRealm)
    }
}
