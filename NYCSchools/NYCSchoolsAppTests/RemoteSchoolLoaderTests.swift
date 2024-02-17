//
//  RemoteSchoolLoaderTests.swift
//  NYCSchoolsAppTests
//
//  Created by Nikhil Lalam on 2/16/24.
//

import XCTest
@testable import NYCSchoolsApp

final class RemoteSchoolLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_load_requestDataFromURL() {
        
        let url = anyUrl()
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_RequestDataFromURLTwice() {
        let url = anyUrl()
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.completion(with: clientError)
        }
    }
    
    func test_load_deliversErrorOnNon200HttpResponse() {
        let (sut, client) = makeSUT()
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index, code in
            
            expect(sut, toCompleteWith: failure(.invalidData)) {
                client.completion(withStatusCode: code, data: anySchoolData(), at: index)
            }
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSOn() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.invalidData)) {
            let invalidJson = Data("invalid Json".utf8)
            client.completion(withStatusCode: 200, data: invalidJson)

        }
    }
    
    func test_load_deliverNoCountryOn200HTTPResponseWithEmptyJsonList() {
        let (sut, client) = makeSUT()
        
        
        expect(sut, toCompleteWith: .success([])) {
            let emptyListJson = Data("[]".utf8)
            client.completion(withStatusCode: 200, data: emptyListJson)
        }
    }

    func test_load_deliverCountryOn200HTTPResponseWithJson() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .success([mockSchool1(), mockSchool2()])) {
            client.completion(withStatusCode: 200, data: anySchoolData())
        }
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = anyUrl()
        let client = HTTPClientSpy()
        var sut: RemoteSchoolLoader? = RemoteSchoolLoader(url: url, client: client)
        
        var capturedResults = [RemoteSchoolLoader.SchoolResult]()
        sut?.load { capturedResults.append($0) }
        
        sut = nil
        client.completion(withStatusCode: 200, data: anySchoolData())
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    
    // MARK: Helper
    
    private func makeSUT(url: URL = anyUrl()
                         , file: StaticString = #file
                         , line: UInt = #line) -> (sut: RemoteSchoolLoader, client: HTTPClientSpy) {
        
        let client = HTTPClientSpy()
        let sut = RemoteSchoolLoader(url: url, client: client)
        return (sut, client)
    }
    
    
   
    
    private func failure(_ error: RemoteSchoolLoader.Error) -> RemoteSchoolLoader.SchoolResult {
        return .failure(error)
    }
    
    private func expect(_ sut: RemoteSchoolLoader
                        , toCompleteWith expectedResult: RemoteSchoolLoader.SchoolResult
                        , when action: () -> Void
                        , file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for load completion")
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let(.success(receivedCountry), .success(expectedCountry)):
                XCTAssertEqual(receivedCountry, expectedCountry, file: file, line: line)
                
            case let (.failure(receivedError as RemoteSchoolLoader.Error)
                      , .failure(expectedError as RemoteSchoolLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("expected result \(expectedResult) got \(receivedResult) invalid", file: file, line: line)
            }
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
    }
    
    private class HTTPClientSpy: HTTPClient {
        
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func fetch(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func completion(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func completion(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index]
                                           , statusCode: code, httpVersion: nil, headerFields: nil)!
            messages[index].completion(.success((data, response)))
        }
    }
}


