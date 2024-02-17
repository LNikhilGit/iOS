//
//  SchoolListViewModel.swift
//  NYCSchoolsApp
//
//  Created by Nikhil Lalam on 2/16/24.
//

import Foundation

class SchoolListViewModel: ObservableObject {
    
    private var loader: SchoolLoader
    @Published var currentState: LoaderState = .initial
    @Published var isAlertPresent = false
    
    init(loader: SchoolLoader) {
        self.loader = loader
    }
    
    func load() {
        currentState = .loading
        loader.load(completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let schools):
                self.currentState = .completed(schools)
            case .failure(let error):
                self.currentState = .error(error)
                self.isAlertPresent.toggle()
            }
        })
    }
}
