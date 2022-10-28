//
//  DBManager.swift
//  TestPokemonTask
//
//  Created by Zenya Kirilov on 27.10.22.
//

import Foundation
import RealmSwift

protocol DBManagerProtocol {
    func save(pokemonModel: PokemonModelRealm)
    func save(pokemonDescriptionModel: PokemonDescriptionModelRealm)
    func obtainPokemons() -> [PokemonModelRealm]
    func obtainPokemonDescription(primaryKey: Int) -> PokemonDescriptionModelRealm?
    func updatePokemonsImage(id: Int?, imageData: Data?)
}

class DBManager: DBManagerProtocol {
    fileprivate lazy var mainRealm = try! Realm(configuration: .defaultConfiguration)
    
    func save(pokemonModel: PokemonModelRealm) {
        try! mainRealm.write {
            mainRealm.add(pokemonModel)
        }
    }
    
    func save(pokemonDescriptionModel: PokemonDescriptionModelRealm) {
        try! mainRealm.write {
            mainRealm.add(pokemonDescriptionModel)
        }
    }
    
    func obtainPokemons() -> [PokemonModelRealm] {
        let model = mainRealm.objects(PokemonModelRealm.self)
        return Array(model).sorted { $0.id < $1.id }
    }
    
    func obtainPokemonDescription(primaryKey: Int) -> PokemonDescriptionModelRealm? {
        let model = mainRealm.object(ofType: PokemonDescriptionModelRealm.self, forPrimaryKey: primaryKey)
        return model
    }
    
    func updatePokemonsImage(id: Int?, imageData: Data?) {
        guard let id = id,
              let imageData = imageData else { return }
        
        if let pokemonDescription = mainRealm.object(ofType: PokemonDescriptionModelRealm.self, forPrimaryKey: id) {
            try! mainRealm.write {
                pokemonDescription.image = imageData
            }
        }
    }
    
    func deleteAllPokemons() {
        try! mainRealm.write {
            let allPokemons = mainRealm.objects(PokemonModelRealm.self)
            mainRealm.delete(allPokemons)
        }
    }
    
    func deleteAllPokemonDescriptions() {
        try! mainRealm.write {
            let allPokemonDescriptions = mainRealm.objects(PokemonDescriptionModelRealm.self)
            mainRealm.delete(allPokemonDescriptions)
        }
    }
}
