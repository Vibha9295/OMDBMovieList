//
//  OMDBMovieListTests.swift
//  OMDBMovieListTests
//
//  Created by Mac on 22/07/24.
//

import XCTest
@testable import OMDBMovieList

final class OMDBMovieListTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
import XCTest
import Combine
@testable import OMDBMovieList

class MovieSearchViewModelTests: XCTestCase {
    
    var viewModel: MovieSearchViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        viewModel = MovieSearchViewModel()
        cancellables = []
        URLProtocol.registerClass(MockURLProtocol.self)
    }
    
    override func tearDown() {
        viewModel = nil
        cancellables = nil
        URLProtocol.unregisterClass(MockURLProtocol.self)
        super.tearDown()
    }
    
    func testFetchMoviesSuccess() {
        let expectation = self.expectation(description: "Fetch movies successfully")
        
        let jsonString = """
        {
            "Search": [
                {"Title": "Movie 1", "Year": "2024", "Poster": "https://example.com/poster1.jpg", "imdbID": "tt001"},
                {"Title": "Movie 2", "Year": "2024", "Poster": "https://example.com/poster2.jpg", "imdbID": "tt002"}
            ],
            "totalResults": "2",
            "Response": "True"
        }
        """
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, jsonString.data(using: .utf8))
        }
        
        viewModel.$movies
            .dropFirst()
            .sink { movies in
                XCTAssertEqual(movies.count, 2)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchMovies()
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchMoviesFailure() {
        let expectation = self.expectation(description: "Fetch movies failed")
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: nil, headerFields: nil)!
            return (response, "Invalid JSON".data(using: .utf8))
        }
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                XCTAssertEqual(errorMessage, ErrorMessages.decodeError)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchMovies()
        
        wait(for: [expectation], timeout: 5.0)
    }
}

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) -> (HTTPURLResponse, Data?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Handler is unavailable.")
        }
        
        let (response, data) = handler(request)
        
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        if let data = data {
            client?.urlProtocol(self, didLoad: data)
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
