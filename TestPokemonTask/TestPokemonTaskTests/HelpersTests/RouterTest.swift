//
//  RouterTest.swift
//  TestPokemonTaskTests
//
//  Created by Zenya Kirilov on 5.11.22.
//

import XCTest
@testable import TestPokemonTask

class MockNavigationController: UINavigationController {
    var presentedVC: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.presentedVC = viewController
        super.pushViewController(viewController, animated: animated)
    }
}

final class RouterTest: XCTestCase {
    
    var router: RouterProtocol!
    var navigationController = MockNavigationController()
    let assembly = AssemblyModuleBuilder()
    let pokemon = Pokemon(name: "Baz", url: "Bar")
    
    override func setUpWithError() throws {
        router = Router(navigationController: navigationController, assemblyBuilder: assembly)
    }

    override func tearDownWithError() throws {
        router = nil
    }

    func testShowPokemonList() throws {
        router.showPokemonsList()
        let pokemonListViewController = navigationController.presentedVC
        XCTAssertTrue(pokemonListViewController is PokemonListViewController)
    }
    
    func testShowDetails() throws {
        router.showDetails(pokemon: pokemon, id: nil)
        let detailViewController = navigationController.presentedVC
        XCTAssertTrue(detailViewController is DetailViewController)
    }

}
