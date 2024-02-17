//
//  NYCSchoolsAppApp.swift
//  NYCSchoolsApp
//
//  Created by Nikhil Lalam on 2/16/24.
//

import SwiftUI

@main
struct NYCSchoolsAppApp: App {
    
   
    
    var body: some Scene {
        WindowGroup {
            SchoolListView(viewModel: createViewModel())
        }
    }
    
    private func createViewModel() -> SchoolListViewModel {
        
        let url = URL(string: "https://data.cityofnewyork.us/resource/s3k6-pzi2.json")!
        let client = URLSessionHttpClient()
        let remoteSchoolLoader = RemoteSchoolLoaderDecorator(decorate: RemoteSchoolLoader(url: url, client: client))
        let viewModel = SchoolListViewModel(loader: remoteSchoolLoader)
        return viewModel
    }
}
