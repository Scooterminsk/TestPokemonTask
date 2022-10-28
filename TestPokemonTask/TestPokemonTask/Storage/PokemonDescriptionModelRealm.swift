//
//  PokemonDescriptionModelRealm.swift
//  TestPokemonTask
//
//  Created by Zenya Kirilov on 27.10.22.
//

import Foundation
import RealmSwift

class PokemonDescriptionModelRealm: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var height = 0
    @Persisted var name = ""
    @Persisted var types = ""
    @Persisted var weight = 0
    @Persisted var image = Data()
}
