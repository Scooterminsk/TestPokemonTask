//
//  PokemonDescriptionModel.swift
//  TestPokemonTask
//
//  Created by Zenya Kirilov on 25.10.22.
//

import Foundation

struct Species: Codable {
    let name: String
    let url: String
}

struct TypeElement: Codable {
    let slot: Int
    let type: Species
}

struct PokemonDescription: Codable {
    let height: Int
    let name: String
    let types: [TypeElement]
    let weight: Int

    enum CodingKeys: String, CodingKey {
        case height
        case name
        case types
        case weight
    }
}
