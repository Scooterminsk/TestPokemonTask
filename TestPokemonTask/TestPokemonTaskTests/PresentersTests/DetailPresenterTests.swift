//
//  DetailPresenterTests.swift
//  TestPokemonTaskTests
//
//  Created by Zenya Kirilov on 6.11.22.
//

import XCTest
@testable import TestPokemonTask

class DetailViewSpy: DetailViewProtocol {
    
    var didPokemonDescriptionSuccessCalled = false
    var didPokemonDescriptionSuccessRealmCalled = false
    var didPokemonDescriptionFailureCalled = false
    var didSetPokemonImageCalled = false
    
    func pokemonDescriptionSuccess() {
        didPokemonDescriptionSuccessCalled = true
    }
    
    func pokemonDescriptionSuccessRealm(name: String, height: Int, weight: Int, types: String) {
        didPokemonDescriptionSuccessRealmCalled = true
    }
    
    func pokemonDescriptionFailure(error: Error) {
        didPokemonDescriptionFailureCalled = true
    }
    
    func setPokemonImage(imageData: Data?) {
        didSetPokemonImageCalled = true
    }
}

final class DetailPresenterTests: XCTestCase {

    var presenter: DetailPresenterProtocol!
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

    func testGetPokemonDescription_isItSuccessfullyObtained_viewSuccessCalled() throws {
        let view = DetailViewSpy()
        let networkMonitor = NetworkMonitorNotConnectedDummy()
        let networkRequestService = MockNetworkRequestService()
        let networkFetchService = MockNetworkFetchService(networkRequestService: networkRequestService)
        let dbManager = MockDbManager()
        let pokemon = Pokemon(name: "Baz", url: "Bar")
        
        presenter = DetailPresenter(view: view,
                                    networkRequestService: networkRequestService,
                                    networkFetchService: networkFetchService,
                                    id: 1, networkMonitor: networkMonitor,
                                    router: router,
                                    dbManager: dbManager,
                                    pokemon: pokemon)
        
        presenter.getPokemonDescription()
        
        XCTAssertTrue(dbManager.didPokemonDescriptionObtained)
        XCTAssertTrue(view.didPokemonDescriptionSuccessRealmCalled)
        XCTAssertTrue(view.didSetPokemonImageCalled)
    }
    
    func testSavePokemonDescriptionRealm_isPokemonDescriptionSaved() throws {
        let view = DetailViewSpy()
        let networkMonitor = NetworkMonitorSpy()
        let networkRequestService = MockNetworkRequestService()
        let networkFetchService = MockNetworkFetchService(networkRequestService: networkRequestService)
        let dbManager = MockDbManager()
        let pokemon = Pokemon(name: "Baz", url: "Bar")
        
        presenter = DetailPresenter(view: view,
                                    networkRequestService: networkRequestService,
                                    networkFetchService: networkFetchService,
                                    id: 1, networkMonitor: networkMonitor,
                                    router: router,
                                    dbManager: dbManager,
                                    pokemon: pokemon)
        
        let pokemonDescriptionModel = PokemonDescriptionModel(height: 1, name: "Baz",
                                                              types: [PokemonDescriptionModel.TypeElement.init(slot: 1, type: PokemonDescriptionModel.Species.init(name: "Bar", url: "Foo"))],
                                                              weight: 1,
                                                              sprites: PokemonDescriptionModel.Sprites.init(other: .none))
        
        presenter.savePokemonDescriptionRealm(pokemon: pokemonDescriptionModel, id: presenter.id)
        
        XCTAssertTrue(dbManager.didPokemonDescriptionModelSaved)
    }
    
    func testGetPokemonDescriptionFromApi_notEmptyPokemonDescriptionModel() {
        let view = DetailViewSpy()
        let networkMonitor = NetworkMonitorSpy()
        let networkRequestService = MockNetworkRequestService()
        let pokemonDescriptionModel = PokemonDescriptionModel(height: 1, name: "Baz",
                                                              types: [PokemonDescriptionModel.TypeElement.init(slot: 1, type: PokemonDescriptionModel.Species.init(name: "Bar", url: "Foo"))],
                                                              weight: 1,
                                                              sprites: PokemonDescriptionModel.Sprites.init(other: .none))
        let networkFetchService = MockNetworkFetchService(networkRequestService: networkRequestService, pokemonDescriptionModel: pokemonDescriptionModel)
        let dbManager = MockDbManager()
        let pokemon = Pokemon(name: "Baz", url: "Bar")
        let funcExpectation = expectation(description: "Expectation in" + #function)
        
        presenter = DetailPresenter(view: view,
                                    networkRequestService: networkRequestService,
                                    networkFetchService: networkFetchService,
                                    id: 1, networkMonitor: networkMonitor,
                                    router: router,
                                    dbManager: dbManager,
                                    pokemon: pokemon)
        
        presenter.getPokemonDescriptionFromAPI()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            funcExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
        
        XCTAssertEqual(presenter.pokemonDescription, pokemonDescriptionModel)
        XCTAssertTrue(view.didPokemonDescriptionSuccessCalled)
    }
    
    func testGetPokemonDescriptionFromApi_errorCatching() {
        let view = DetailViewSpy()
        let networkMonitor = NetworkMonitorSpy()
        let networkRequestService = MockNetworkRequestService()
        let networkFetchService = MockNetworkFetchService(networkRequestService: networkRequestService)
        let dbManager = MockDbManager()
        let pokemon = Pokemon(name: "Baz", url: "Bar")
        let funcExpectation = expectation(description: "Expectation in" + #function)
        
        presenter = DetailPresenter(view: view,
                                    networkRequestService: networkRequestService,
                                    networkFetchService: networkFetchService,
                                    id: 1, networkMonitor: networkMonitor,
                                    router: router,
                                    dbManager: dbManager,
                                    pokemon: pokemon)
        
        presenter.getPokemonDescriptionFromAPI()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            funcExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
        
        XCTAssertTrue(networkFetchService.didDescriptionErrorCatched)
        XCTAssertTrue(view.didPokemonDescriptionFailureCalled)
    }
    
    func testGetPokemonImage_notEmptyData() {
        let view = DetailViewSpy()
        let networkMonitor = NetworkMonitorSpy()
        let networkRequestService = MockNetworkRequestService(simpleData: Data([1, 2, 3, 4, 5]))
        let networkFetchService = MockNetworkFetchService(networkRequestService: networkRequestService)
        let dbManager = MockDbManager()
        let pokemon = Pokemon(name: "Baz", url: "Bar")
        let funcExpectation = expectation(description: "Expectation in" + #function)
        
        presenter = DetailPresenter(view: view,
                                    networkRequestService: networkRequestService,
                                    networkFetchService: networkFetchService,
                                    id: 1, networkMonitor: networkMonitor,
                                    router: router,
                                    dbManager: dbManager,
                                    pokemon: pokemon)
        
        presenter.getPokemonImage(urlString: "Bar")
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            funcExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
        
        XCTAssertTrue(view.didSetPokemonImageCalled)
    }
    
    func testGetPokemonImage_errorCatching() {
        let view = DetailViewSpy()
        let networkMonitor = NetworkMonitorSpy()
        let networkRequestService = MockNetworkRequestService()
        let networkFetchService = MockNetworkFetchService(networkRequestService: networkRequestService)
        let dbManager = MockDbManager()
        let pokemon = Pokemon(name: "Baz", url: "Bar")
        
        presenter = DetailPresenter(view: view,
                                    networkRequestService: networkRequestService,
                                    networkFetchService: networkFetchService,
                                    id: 1, networkMonitor: networkMonitor,
                                    router: router,
                                    dbManager: dbManager,
                                    pokemon: pokemon)
        
        presenter.getPokemonImage(urlString: "Bar")
        
        XCTAssertTrue(networkRequestService.didErrorCatched)
    }
}
