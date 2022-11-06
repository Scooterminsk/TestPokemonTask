//
//  PokemonDescriptionModel.swift
//  TestPokemonTask
//
//  Created by Zenya Kirilov on 25.10.22.
//

import Foundation

struct PokemonDescriptionModel: Decodable, Equatable {
    let height: Int
    let name: String
    let types: [TypeElement]
    let weight: Int
    let sprites: Sprites
}

extension PokemonDescriptionModel {
    struct TypeElement: Decodable, Equatable {
        let slot: Int
        let type: Species
    }

    struct Species: Decodable, Equatable {
        let name: String
        let url: String
    }

    struct Sprites: Decodable, Equatable {
        let other: Other?
    }

    struct Other: Decodable, Equatable {
        let home: Home
    }

    struct Home: Decodable, Equatable {
        let front_default: String
    }
}
