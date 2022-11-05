//
//  PokemonDescriptionModel.swift
//  TestPokemonTask
//
//  Created by Zenya Kirilov on 25.10.22.
//

import Foundation

struct PokemonDescriptionModel: Decodable {
    let height: Int
    let name: String
    let types: [TypeElement]
    let weight: Int
    let sprites: Sprites
}

extension PokemonDescriptionModel {
    struct TypeElement: Decodable {
        let slot: Int
        let type: Species
    }

    struct Species: Decodable {
        let name: String
        let url: String
    }

    struct Sprites: Decodable {
        let other: Other?
    }

    struct Other: Decodable {
        let home: Home
    }

    struct Home: Decodable {
        let front_default: String
    }
}
