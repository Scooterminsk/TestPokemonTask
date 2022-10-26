//
//  PokemonDescriptionModel.swift
//  TestPokemonTask
//
//  Created by Zenya Kirilov on 25.10.22.
//

import Foundation

struct PokemonDescriptionModel: Codable {
    let height: Int
    let name: String
    let types: [TypeElement]
    let weight: Int
    let sprites: Sprites
}

struct TypeElement: Codable {
    let slot: Int
    let type: Species
}

struct Species: Codable {
    let name: String
    let url: String
}

struct Sprites: Codable {
    let other: Other?
}

struct Other: Codable {
    let home: Home
}

struct Home: Codable {
    let front_default: String
}
