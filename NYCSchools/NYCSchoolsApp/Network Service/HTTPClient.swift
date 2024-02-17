//
//  HTTPClient.swift
//  NYCSchoolsApp
//
//  Created by Nikhil Lalam on 2/16/24.
//

import Foundation

// HTTPClient Protocol is boundary protocol for Networking Module
// We are returning Data in completion handler so that we reuse.
// Loader will be responsible to parse the data, and Error Handling as per there own requirement.

public protocol HTTPClient {
    
    typealias HTTPClientResult = Result<(Data, HTTPURLResponse), Error>
    
    func fetch(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
