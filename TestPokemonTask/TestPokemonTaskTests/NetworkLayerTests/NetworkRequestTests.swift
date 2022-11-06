//
//  NetworkRequestTests.swift
//  TestPokemonTaskTests
//
//  Created by Zenya Kirilov on 6.11.22.
//

import XCTest
@testable import TestPokemonTask

class URLSessionMockData: URLSession {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    // data and error can be set to provide data or an error
    var data = Data([1, 2, 3, 4, 5])
    var error: Error?
    override func dataTask(with url: URL, completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {
        let data = self.data
        completionHandler(data, nil, nil)
        return URLSession.shared.dataTask(with: url)
    }
}

class URLSessionMockError: URLSession {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    // data and error can be set to provide data or an error
    var data: Data?
    var error: Error?
    override func dataTask(with url: URL, completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {
        let error = NSError(domain: "RequestTests", code: 4)
        completionHandler(nil, nil, error)
        return URLSession.shared.dataTask(with: url)
    }
}

final class NetworkRequestTests: XCTestCase {
    var networkRequestService: NetworkRequestProtocol?

    override func tearDownWithError() throws {
        networkRequestService = nil
    }

    func testRequest_success() throws {
        let urlSessionObject = URLSessionMockData.shared
        networkRequestService = NetworkRequest(urlSessionObject: urlSessionObject)
        let funcExpectation = expectation(description: "Expectation in" + #function)
        var catchedData: Data?
        
        networkRequestService?.requestData(urlString: "https://pokeapi.co/api/v2/pokemon", completion: { result in
            switch result {
            case .success(let data):
                catchedData = data
            case .failure(_):
                return
            }
        })
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            funcExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
        
        XCTAssertNotNil(catchedData)
    }

    func testRequest_failure() throws {
        let urlSessionObject = URLSessionMockError.shared
        networkRequestService = NetworkRequest(urlSessionObject: urlSessionObject)
        let funcExpectation = expectation(description: "Expectation in" + #function)
        var cathedError: Error?
        
        networkRequestService?.requestData(urlString: "Baz", completion: { result in
            switch result {
            case .success(_):
                return
            case .failure(let error):
                cathedError = error
            }
        })
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            funcExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
        
        XCTAssertNotNil(cathedError)
    }

}
