//
//  PokemonDescriptionModel.swift
//  TestPokemonTask
//
//  Created by Zenya Kirilov on 25.10.22.
//

import Foundation

struct PokemonDescriptionModel: Codable, Equatable {
    let height: Int
    let name: String
    let types: [TypeElement]
    let weight: Int
    let sprites: Sprites
}

extension PokemonDescriptionModel {
    struct TypeElement: Codable, Equatable {
        let slot: Int
        let type: Species
    }

    struct Species: Codable, Equatable {
        let name: String
        let url: String
    }

    struct Sprites: Codable, Equatable {
        let other: Other?
    }

    struct Other: Codable, Equatable {
        let home: Home
    }

    struct Home: Codable, Equatable {
        let front_default: String
    }
}
