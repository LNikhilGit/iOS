//
//  LoaderState.swift
//  NYCSchoolsApp
//
//  Created by Nikhil Lalam on 2/16/24.
//

import Foundation

enum LoaderState {
    case initial
    case loading
    case error(Error)
    case completed([SchoolInfo])
}
