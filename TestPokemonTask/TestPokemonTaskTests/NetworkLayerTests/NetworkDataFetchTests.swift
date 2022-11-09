//
//  NetworkDataFetchTests.swift
//  TestPokemonTaskTests
//
//  Created by Zenya Kirilov on 6.11.22.
//

import XCTest
@testable import TestPokemonTask

class MockNetworkRequest: NetworkRequestProtocol {

    var simpleData: Data?
    var didErrorCatched = false
    
    convenience init(pokemonModel: PokemonModel) {
        self.init()
        do {
            self.simpleData = try JSONEncoder().encode(pokemonModel)
        } catch let error {
            Log.error(error.localizedDescription)
        }
    }
    
    convenience init(pokemonDescriptionModel: PokemonDescriptionModel) {
        self.init()
        do {
            self.simpleData = try JSONEncoder().encode(pokemonDescriptionModel)
        } catch let error {
            Log.error(error.localizedDescription)
        }
    }
    
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

final class NetworkDataFetchTests: XCTestCase {
    
    var networkDataFetch: NetworkDataFetchProtocol!

    override func tearDownWithError() throws {
        networkDataFetch = nil
    }

    func testFetchPokemons_success() throws {
        let pokemonModel = PokemonModel(results: [Pokemon(name: "Baz", url: "Bar"), Pokemon(name: "Bar", url: "Foo")])
        let networkRequestService = MockNetworkRequest(pokemonModel: pokemonModel)
        let funcExpectation = expectation(description: "Expectation in" + #function)
        
        var catchedPokemonModel: PokemonModel?

        networkDataFetch = NetworkDataFetch(networkRequestService: networkRequestService)
        
        networkDataFetch.fetchPokemons(pagination: false) { pokemonModel, error in
            if error == nil {
                catchedPokemonModel = pokemonModel
            } else {
                guard let error = error else { return }
                Log.error(error.localizedDescription)
            }
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            funcExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
        
        XCTAssertNotNil(catchedPokemonModel)
        XCTAssertEqual(pokemonModel, catchedPokemonModel)
    }
    
    func testFetchPokemons_jsonError() throws {
        let networkRequestService = MockNetworkRequest(simpleData: Data([1, 2, 3, 4, 5]))
        let funcExpectation = expectation(description: "Expectation in" + #function)
        
        var catchedJsonError: Error?

        networkDataFetch = NetworkDataFetch(networkRequestService: networkRequestService)
        
        networkDataFetch.fetchPokemons(pagination: false) { pokemonModel, error in
            if error == nil {
                return
            } else {
                guard let error = error else { return }
                catchedJsonError = error
                Log.error(error.localizedDescription)
            }
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            funcExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
        
        XCTAssertNotNil(catchedJsonError)
    }
    
    func testFetchPokemons_errorFailure() throws {
        let networkRequestService = MockNetworkRequest()
        let funcExpectation = expectation(description: "Expectation in" + #function)
        
        var catchedError: Error?

        networkDataFetch = NetworkDataFetch(networkRequestService: networkRequestService)
        
        networkDataFetch.fetchPokemons(pagination: false) { pokemonModel, error in
            if error == nil {
                return
            } else {
                guard let error = error else { return }
                catchedError = error
                Log.error(error.localizedDescription)
            }
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            funcExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
        
        XCTAssertNotNil(catchedError)
    }
    
    func testFetchPokemonDescription_success() throws {
        let pokemonDescriptionModel = PokemonDescriptionModel(height: 1, name: "Baz",
                                                              types: [PokemonDescriptionModel.TypeElement.init(slot: 1, type: PokemonDescriptionModel.Species.init(name: "Bar", url: "Foo"))],
                                                              weight: 1,
                                                              sprites: PokemonDescriptionModel.Sprites.init(other: .none))
        let networkRequestService = MockNetworkRequest(pokemonDescriptionModel: pokemonDescriptionModel)
        let funcExpectation = expectation(description: "Expectation in" + #function)
        
        var catchedPokemonDescriptionModel: PokemonDescriptionModel?

        networkDataFetch = NetworkDataFetch(networkRequestService: networkRequestService)
        
        networkDataFetch.fetchPokemonDescription(urlString: "Bar") { pokemonDescriptionModel, error in
            if error == nil {
                catchedPokemonDescriptionModel = pokemonDescriptionModel
            } else {
                guard let error = error else { return }
                Log.error(error.localizedDescription)
            }
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            funcExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
        
        XCTAssertNotNil(catchedPokemonDescriptionModel)
        XCTAssertEqual(pokemonDescriptionModel, catchedPokemonDescriptionModel)
    }
    
    func testFetchPokemonDescription_jsonError() throws {
        let networkRequestService = MockNetworkRequest(simpleData: Data([1, 2, 3, 4, 5]))
        let funcExpectation = expectation(description: "Expectation in" + #function)
        
        var catchedJsonError: Error?

        networkDataFetch = NetworkDataFetch(networkRequestService: networkRequestService)
        
        networkDataFetch.fetchPokemonDescription(urlString: "Bar") { pokemonDescriptionModel, error in
            if error == nil {
                return
            } else {
                guard let error = error else { return }
                catchedJsonError = error
                Log.error(error.localizedDescription)
            }
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            funcExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
        
        XCTAssertNotNil(catchedJsonError)
    }
    
    func testFetchPokemonDescription_errorFailure() throws {
        let networkRequestService = MockNetworkRequest()
        let funcExpectation = expectation(description: "Expectation in" + #function)
        
        var catchedError: Error?

        networkDataFetch = NetworkDataFetch(networkRequestService: networkRequestService)
        
        networkDataFetch.fetchPokemonDescription(urlString: "Bar") { pokemonDescriptionModel, error in
            if error == nil {
                return
            } else {
                guard let error = error else { return }
                catchedError = error
                Log.error(error.localizedDescription)
            }
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            funcExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
        
        XCTAssertNotNil(catchedError)
    }

}
