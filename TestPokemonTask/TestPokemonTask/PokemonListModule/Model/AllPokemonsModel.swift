//
//  AllPokemonsModel.swift
//  TestPokemonTask
//
//  Created by Zenya Kirilov on 25.10.22.
//

import Foundation

struct PokemonModel: Codable, Equatable {
    let results: [Pokemon]
}

struct Pokemon: Codable, Equatable {
    let name: String
    let url: String
}
