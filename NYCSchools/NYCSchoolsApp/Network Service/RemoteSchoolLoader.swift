//
//  RemoteSchoolLoader.swift
//  NYCSchoolsApp
//
//  Created by Nikhil Lalam on 2/16/24.
//

import Foundation


public final class RemoteSchoolLoader: SchoolLoader {
   
    private let url: URL
    private let client: HTTPClient
    
    public typealias SchoolResult =  LoadSchoolResult
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (SchoolResult) -> Void) {
        client.fetch(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                completion(RemoteSchoolLoader.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> SchoolResult {
        do {
            let countries = try SchoolMapper.map(data, response: response)
            return .success(countries)
        } catch {
            return .failure(RemoteSchoolLoader.Error.invalidData)
        }
    }
    
}

internal final class SchoolMapper {
    
    static func map(_ data: Data, response: HTTPURLResponse) throws -> [SchoolInfo] {
        guard response.statusCode == 200 else {
            throw RemoteSchoolLoader.Error.invalidData
        }
        return try JSONDecoder().decode([SchoolInfo].self, from: data)
    }
}


