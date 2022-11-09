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
        let alert = UIAlertController(title: R.string.staticStrings.alertNoNetworkAndCacheTitle(), message: R.string.staticStrings.alertNoNetworkAndCacheMessage(), preferredStyle: .alert)
        let actionOK = UIAlertAction(title: R.string.staticStrings.ok(), style: .default, handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        })
        alert.addAction(actionOK)
        present(alert, animated: true)
    }
}
