//
//  AllPokemonsModel.swift
//  TestPokemonTask
//
//  Created by Zenya Kirilov on 25.10.22.
//

import Foundation

struct PokemonModel: Decodable, Equatable {
    let results: [Pokemon]
}

struct Pokemon: Decodable, Equatable {
    let name: String
    let url: String
}
