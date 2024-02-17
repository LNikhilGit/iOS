//
//  NetworkManager .swift
//  NYCSchoolsApp
//
//  Created by Nikhil Lalam on 2/16/24.
//

// API: https://data.cityofnewyork.us/resource/s3k6-pzi2.json

import Foundation


public final class URLSessionHttpClient: HTTPClient {
    
    private var urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    struct UnexpectedValueRepresentation: Error { }
    
    public func fetch(from url: URL, completion : @escaping (HTTPClientResult) -> Void) {

       let task = urlSession.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data,
                      let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            } else {
                completion(.failure(UnexpectedValueRepresentation()))
            }
        }
        task.resume()
    }
}

