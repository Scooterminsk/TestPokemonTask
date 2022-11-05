//
//  SceneDelegate.swift
//  TestPokemonTask
//
//  Created by Zenya Kirilov on 25.10.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        let navigationViewController = UINavigationController()
        let assemblyModuleBuilder = AssemblyModuleBuilder()
        let router = Router(navigationController: navigationViewController, assemblyBuilder: assemblyModuleBuilder)
        router.initialViewController()

        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()
    }
}

