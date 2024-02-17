//
//  Mocks.swift
//  NYCSchoolsAppTests
//
//  Created by Nikhil Lalam on 17/02/24.
//

import Foundation
@testable import NYCSchoolsApp

public func mockSchool1() -> SchoolInfo {
    SchoolInfo(dbn: "02M260"
            , name: "Clinton School Writers & Artists, M.S. 260"
            , boro: "M"
            , overview: "Overview"
            , phoneNumber: "123456789"
               , email: "example@gmail.com"
               , website: "https://anyurl1.com"
               , totalStudents: "250"
               , attendanceRate: "120"
               , latitude: "1235.01"
               , longitude: "123.02"
               , borough: "MANHATTAN")
}

public func mockSchool2() -> SchoolInfo {
    SchoolInfo(dbn: "02M2601"
            , name: "Liberation Diploma Plus High School"
            , boro: "K"
            , overview: "Overview"
            , phoneNumber: "987654321"
               , email: "example@gmail.com"
               , website: "https://anyurl2.com"
               , totalStudents: "60"
               , attendanceRate: "50"
               , latitude: "1235.01"
               , longitude: "123.02"
               , borough: "BROOKLYN")
}


public func anyUrl() -> URL {
    return URL(string: "https://any-url.com")!
}

public func anySchoolData() -> Data {
    return try! JSONEncoder().encode([mockSchool1(), mockSchool2()])
}

public func anyError() -> NSError {
    return NSError(domain: "Any Error", code: 0)
}

extension SchoolInfo: Equatable {
    
    public static func == (lhs: SchoolInfo, rhs: SchoolInfo) -> Bool {
        return lhs.dbn == rhs.dbn &&
        lhs.attendanceRate == rhs.attendanceRate &&
        lhs.boro == rhs.boro &&
        lhs.borough == rhs.borough &&
        lhs.email == rhs.email &&
        lhs.latitude == rhs.latitude &&
        lhs.longitude == rhs.longitude &&
        lhs.phoneNumber == rhs.phoneNumber &&
        lhs.website == rhs.website &&
        lhs.name == rhs.name &&
        lhs.overview == rhs.overview
        
    }
}

extension LoaderState: Equatable {
    
    public static func == (lhs: LoaderState, rhs: LoaderState) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial), (.loading, .loading):
            return true
        case let (.completed(lhsSchoolInfo), .completed(rhsSchoolInfo)):
            return lhsSchoolInfo == rhsSchoolInfo
        case let (.error(lhsError), .error(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
