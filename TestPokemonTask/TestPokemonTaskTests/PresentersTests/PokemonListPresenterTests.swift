//
//  PokemonListPresenterTests.swift
//  TestPokemonTaskTests
//
//  Created by Zenya Kirilov on 6.11.22.
//

import XCTest
@testable import TestPokemonTask

class PokemonListViewSpy: PokemonListViewProtocol {
    var didSuccessCalled = false
    var didFailureCalled = false
    
    func success() {
        didSuccessCalled = true
    }
    
    func failure(error: Error) {
        didFailureCalled = true
    }
}

class MockDbManager: DBManagerProtocol {
    var didPokemonModelSaved = false
    var didPokemonDescriptionModelSaved = false
    var didPokemonDescriptionObtained = false
    
    func save(pokemonModel: TestPokemonTask.PokemonModelRealm) {
        didPokemonModelSaved = true
    }
    
    func save(pokemonDescriptionModel: TestPokemonTask.PokemonDescriptionModelRealm) {
        didPokemonDescriptionModelSaved = true
    }
    
    func obtainPokemons() -> [TestPokemonTask.PokemonModelRealm] {
        let pokemon1 = PokemonModelRealm()
        let pokemon2 = PokemonModelRealm()
        return [pokemon1, pokemon2]
    }
    
    func obtainPokemonDescription(primaryKey: Int) -> TestPokemonTask.PokemonDescriptionModelRealm? {
        let pokemonDescription = PokemonDescriptionModelRealm()
        didPokemonDescriptionObtained = true
        return pokemonDescription
    }
    
    func updatePokemonsImage(id: Int?, imageData: Data?) {
        
    }
}

class MockNetworkRequestService: NetworkRequestProtocol {

    var simpleData: Data?
    var didErrorCatched = false
    
    convenience init(simpleData: Data) {
        self.init()
        self.simpleData = simpleData
    }
    
    func requestData(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        if let simpleData = simpleData {
            completion(.success(simpleData))
        } else {
            let error = NSError(domain: "RequestTest", code: 2)
            didErrorCatched = true
            completion(.failure(error))
        }
    }
}

class MockNetworkFetchService: NetworkDataFetchProtocol {
    let networkRequestService: NetworkRequestProtocol!
    var pokemons: [Pokemon]?
    var pokemonModel: PokemonModel?
    var pokemonDescriptionModel: PokemonDescriptionModel?
    
    var didErrorCatched = false
    var didDescriptionErrorCatched = false
    
    required init(networkRequestService: TestPokemonTask.NetworkRequestProtocol) {
        self.networkRequestService = networkRequestService
    }
    
    convenience init(networkRequestService: TestPokemonTask.NetworkRequestProtocol, pokemons: [Pokemon]) {
        self.init(networkRequestService: networkRequestService)
        self.pokemons = pokemons
        self.pokemonModel = PokemonModel(results: pokemons)
    }
    
    convenience init(networkRequestService: TestPokemonTask.NetworkRequestProtocol, pokemonDescriptionModel: PokemonDescriptionModel) {
        self.init(networkRequestService: networkRequestService)
        self.pokemonDescriptionModel = pokemonDescriptionModel
    }
    
    func fetchPokemons(pagination: Bool, response: @escaping (TestPokemonTask.PokemonModel?, Error?) -> Void) {
        if let pokemonModel = pokemonModel {
            response(pokemonModel, nil)
        } else {
            let error = NSError(domain: "FetchTest", code: 0)
            didErrorCatched = true
            response(nil, error)
        }
    }
    
    func fetchPokemonDescription(urlString: String, response: @escaping (TestPokemonTask.PokemonDescriptionModel?, Error?) -> Void) {
        if let pokemonDescriptionModel = pokemonDescriptionModel {
            response(pokemonDescriptionModel, nil)
        } else {
            let error = NSError(domain: "FetchDescriptionTest", code: 1)
            didDescriptionErrorCatched = true
            response(nil, error)
        }
    }
}

final class PokemonListPresenterTests: XCTestCase {
    
    var presenter: PokemonListPresenterProtocol!
    var router: RouterProtocol!

    override func setUpWithError() throws {
        let navigationVC = UINavigationController()
          let assembly = AssemblyModuleBuilder()
          router = Router(navigationController: navigationVC, assemblyBuilder: assembly)
    }

    override func tearDownWithError() throws {
        router = nil
        presenter = nil
    }

    func testGetPokemons_areTheySuccessfullyObtained_viewSuccessCalled() throws {
        let view = PokemonListViewSpy()
        let networkMonitor = NetworkMonitorNotConnectedDummy()
        let networkRequestService = MockNetworkRequestService()
        let networkFetchService = MockNetworkFetchService(networkRequestService: networkRequestService)
        let dbManager = MockDbManager()
        
        presenter = PokemonListPresenter(view: view, networkFetchService: networkFetchService, networkMonitor: networkMonitor, router: router, dbManager: dbManager)
        
        presenter.getPokemons()
        
        XCTAssertTrue((presenter.pokemons?.count ?? 0) > 0)
        XCTAssertTrue(view.didSuccessCalled)
    }

    func testSavePokemonsRealm_arePokemonsSaved() throws {
        let view = PokemonListViewSpy()
        let networkMonitor = NetworkMonitorNotConnectedDummy()
        let networkRequestService = MockNetworkRequestService()
        let networkFetchService = MockNetworkFetchService(networkRequestService: networkRequestService)
        let dbManager = MockDbManager()
        
        presenter = PokemonListPresenter(view: view, networkFetchService: networkFetchService, networkMonitor: networkMonitor, router: router, dbManager: dbManager)
        
        let pokemons = [Pokemon(name: "Baz", url: "Bar"), Pokemon(name: "Bar", url: "Foo")]
        
        presenter.savePokemonsRealm(pokemons: pokemons, startIndex: 0)
        
        XCTAssertTrue(dbManager.didPokemonModelSaved)
    }
    
    func testGetPokemonsFromApi_notEmptyPokemonsModel() throws {
        let view = PokemonListViewSpy()
        let networkMonitor = NetworkMonitorSpy()
        let networkRequestService = MockNetworkRequestService()
        let pokemons = [Pokemon(name: "Baz", url: "Bar"), Pokemon(name: "Bar", url: "Foo")]
        let networkFetchService = MockNetworkFetchService(networkRequestService: networkRequestService, pokemons: pokemons)
        let dbManager = MockDbManager()
        
        presenter = PokemonListPresenter(view: view, networkFetchService: networkFetchService, networkMonitor: networkMonitor, router: router, dbManager: dbManager)
        
        presenter.getPokemonsFromAPI()
        
        XCTAssertEqual(presenter.pokemons, pokemons)
    }
    
    func testGetPokemonsFromApi_errorCatching() throws {
        let view = PokemonListViewSpy()
        let networkMonitor = NetworkMonitorSpy()
        let networkRequestService = MockNetworkRequestService()
        let networkFetchService = MockNetworkFetchService(networkRequestService: networkRequestService)
        let dbManager = MockDbManager()
        
        presenter = PokemonListPresenter(view: view, networkFetchService: networkFetchService, networkMonitor: networkMonitor, router: router, dbManager: dbManager)
        
        presenter.getPokemonsFromAPI()
        
        XCTAssertTrue(networkFetchService.didErrorCatched)
        XCTAssertTrue(view.didFailureCalled)
    }
    
    func testGetPokemonsPagination_notEmptyPokemonsModel() throws {
        let view = PokemonListViewSpy()
        let networkMonitor = NetworkMonitorSpy()
        let networkRequestService = MockNetworkRequestService()
        let pokemons = [Pokemon(name: "Baz", url: "Bar"), Pokemon(name: "Bar", url: "Foo")]
        let networkFetchService = MockNetworkFetchService(networkRequestService: networkRequestService, pokemons: pokemons)
        let dbManager = MockDbManager()
        
        presenter = PokemonListPresenter(view: view, networkFetchService: networkFetchService, networkMonitor: networkMonitor, router: router, dbManager: dbManager)
        
        presenter.getPokemonsPagination()
        
        XCTAssertTrue(((presenter.pokemons?.contains(pokemons)) != nil))
    }
    
    func testGetPokemonsPagination_errorCatching() throws {
        let view = PokemonListViewSpy()
        let networkMonitor = NetworkMonitorSpy()
        let networkRequestService = MockNetworkRequestService()
        let networkFetchService = MockNetworkFetchService(networkRequestService: networkRequestService)
        let dbManager = MockDbManager()
        
        presenter = PokemonListPresenter(view: view, networkFetchService: networkFetchService, networkMonitor: networkMonitor, router: router, dbManager: dbManager)
        
        presenter.getPokemonsPagination()
        
        XCTAssertTrue(networkFetchService.didErrorCatched)
        XCTAssertTrue(view.didFailureCalled)
    }

}
