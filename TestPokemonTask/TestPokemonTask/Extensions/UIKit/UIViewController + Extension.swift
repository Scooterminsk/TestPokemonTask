//
//  UIViewController + Extension.swift
//  TestPokemonTask
//
//  Created by Zenya Kirilov on 27.10.22.
//

import Foundation
import UIKit

extension UIViewController {
    func alertNoNetworkAndCache() {
        let alert = UIAlertController(title: "No internet connection", message: "You can continue to use the application if you already have downloaded Pokemons", preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .default)
        alert.addAction(actionOK)
        present(alert, animated: true)
    }
}
