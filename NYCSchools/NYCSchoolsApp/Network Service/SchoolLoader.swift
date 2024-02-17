//
//  SchoolLoader.swift
//  NYCSchoolsApp
//
//  Created by Nikhil Lalam on 17/02/24.
//

import Foundation

public protocol SchoolLoader {
    
    typealias LoadSchoolResult = Result<[SchoolInfo], Error>
    
    func load(completion: @escaping (LoadSchoolResult) -> Void)
}


public class RemoteSchoolLoaderDecorator: SchoolLoader {
    
    var decorate: SchoolLoader
    
    init(decorate: SchoolLoader) {
        self.decorate = decorate
    }

    public func load(completion: @escaping (LoadSchoolResult) -> Void) {
        decorate.load { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
