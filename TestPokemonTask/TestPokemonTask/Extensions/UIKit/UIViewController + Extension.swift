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
        let alert = UIAlertController(title: "Oh, internet connection status has changed", message: "You will be moved to the main screen", preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        })
        alert.addAction(actionOK)
        present(alert, animated: true)
    }
}
