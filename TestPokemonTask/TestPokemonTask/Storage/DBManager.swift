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
    
    private enum ServiceError: Error {
        case internalErrorConnection
        case internalErrorCantWrite
        case internalErrorCantDelete
    }
    
    fileprivate var mainRealm: Realm {
        do {
            let realm = try Realm(configuration: .defaultConfiguration)
            return realm
        } catch ServiceError.internalErrorConnection {
            Log.error("Could not access database", shouldLogContext: true)
        } catch {
            Log.error("Unknown error: \(error.localizedDescription)", shouldLogContext: true)
        }
        return self.mainRealm
    }
    
    func save(pokemonModel: PokemonModelRealm) {
        do {
            try mainRealm.write {
                mainRealm.add(pokemonModel, update: .all)
            }
        } catch ServiceError.internalErrorCantWrite {
            Log.error("Could not write to database", shouldLogContext: true)
        } catch {
            Log.error("Unknown error: \(error.localizedDescription)", shouldLogContext: true)
        }
        
    }
    
    func save(pokemonDescriptionModel: PokemonDescriptionModelRealm) {
        do {
            try mainRealm.write {
                mainRealm.add(pokemonDescriptionModel, update: .all)
            }
        } catch ServiceError.internalErrorCantWrite {
            Log.error("Could not write to database", shouldLogContext: true)
        } catch {
            Log.error("Unknown error: \(error.localizedDescription)", shouldLogContext: true)
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
            } catch ServiceError.internalErrorCantWrite {
                Log.error("Could not write to database", shouldLogContext: true)
            } catch {
                Log.error("Unknown error: \(error.localizedDescription)", shouldLogContext: true)
            }
        }
    }
    
    func deleteAllPokemons() {
        do {
            try mainRealm.write {
                let allPokemons = mainRealm.objects(PokemonModelRealm.self)
                mainRealm.delete(allPokemons)
            }
        } catch ServiceError.internalErrorCantDelete {
            Log.error("Could not delete from database", shouldLogContext: true)
        } catch {
            Log.error("Unknown error: \(error.localizedDescription)", shouldLogContext: true)
        }
    }
    
    func deleteAllPokemonDescriptions() {
        do {
            try mainRealm.write {
                let allPokemonDescriptions = mainRealm.objects(PokemonDescriptionModelRealm.self)
                mainRealm.delete(allPokemonDescriptions)
            }
        } catch ServiceError.internalErrorCantDelete {
            Log.error("Could not delete from database", shouldLogContext: true)
        } catch {
            Log.error("Unknown error: \(error.localizedDescription)", shouldLogContext: true)
        }
    }
}
