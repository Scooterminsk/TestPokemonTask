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

final class DBManager: DBManagerProtocol {
    
    fileprivate var mainRealm: Realm {
        // it was decided not to create an enum with errors, because the Realm will not see them -> it will never be able to throw them
        do {
            let realm = try Realm(configuration: .defaultConfiguration)
            return realm
        } catch {
            Log.error("Could not access database: \(error.localizedDescription)", shouldLogContext: true)
        }
        return self.mainRealm
    }
    
    func save(pokemonModel: PokemonModelRealm) {
        do {
            try mainRealm.write {
                mainRealm.add(pokemonModel, update: .all)
            }
        } catch {
            Log.error("Could not write to database: \(error.localizedDescription)", shouldLogContext: true)
        }
        
    }
    
    func save(pokemonDescriptionModel: PokemonDescriptionModelRealm) {
        do {
            try mainRealm.write {
                mainRealm.add(pokemonDescriptionModel, update: .all)
            }
        } catch {
            Log.error("Could not write to database: \(error.localizedDescription)", shouldLogContext: true)
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
            do {
                try mainRealm.write {
                    pokemonDescription.image = imageData
                }
            } catch {
                Log.error("Could not write to database: \(error.localizedDescription)", shouldLogContext: true)
            }
        }
    }
    
    func deleteAllPokemons() {
        do {
            try mainRealm.write {
                let allPokemons = mainRealm.objects(PokemonModelRealm.self)
                mainRealm.delete(allPokemons)
            }
        } catch {
            Log.error("Could not delete from database: \(error.localizedDescription)", shouldLogContext: true)
        }
    }
    
    func deleteAllPokemonDescriptions() {
        do {
            try mainRealm.write {
                let allPokemonDescriptions = mainRealm.objects(PokemonDescriptionModelRealm.self)
                mainRealm.delete(allPokemonDescriptions)
            }
        } catch {
            Log.error("Could not delete from database: \(error.localizedDescription)", shouldLogContext: true)
        }
    }
}
