//
//  SchoolListView.swift
//  NYCSchoolsApp
//
//  Created by Nikhil Lalam on 2/16/24.
//



import SwiftUI


struct SchoolListView: View {
    
    @ObservedObject var viewModel: SchoolListViewModel 
    
    var body: some View {
        NavigationView {
            ZStack {
                switch viewModel.currentState {
                case .initial:
                    Text("Welcome to NYC")
                case .loading:
                    ProgressView()
                case .error(let error):
                    HStack {}
                        .alert("Error", isPresented: $viewModel.isAlertPresent, actions: {
                            Button("Cancel") {
                                viewModel.isAlertPresent.toggle()
                                viewModel.load()
                            }
                        })
                case .completed(let schoolInfo):
                    List(schoolInfo) { school in
                        NavigationLink {
                            SchoolDetailView(school: school)
                        } label: {
                            Text(school.name)
                        }

                    }
                }
            }
            .navigationTitle("NYC Schools")
        }.onAppear(perform: {
            viewModel.load()
        })
    }
}
