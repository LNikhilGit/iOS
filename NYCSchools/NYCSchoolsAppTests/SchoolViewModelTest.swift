//
//  SchoolViewModelTest.swift
//  NYCSchoolsAppTests
//
//  Created by Nikhil Lalam on 2/16/24..
//

import XCTest
@testable import NYCSchoolsApp


final class SchoolViewModelTest: XCTestCase {
    
    func test_currentStat_ShouldBeInitial_When_Initialize() {
        let (sut, _) = makeSut()
        
        XCTAssertEqual(sut.currentState, .initial, "Expected initial state but found \(sut.currentState)")
    }
    
    func test_currentState_ShouldBeLoading_When_Request_For_Load() {
        let (sut, _) = makeSut()
        sut.load()
        
        XCTAssertEqual(sut.currentState, .loading, "Expected Loading state but found \(sut.currentState)")
    }
    
    func test_currentState_ShouldBeError_When_Received_Error_From_Loader() {
        let error = anyError()
        let (sut, loader) = makeSut()
        
        sut.load()
        loader.completeWith(error: error)
        
        XCTAssertEqual(sut.currentState, .error(error), "Expected Error Loading state but found \(sut.currentState)")
    }
    
    func test_currentState_Completed_When_Received_Data_From_Loader() {
        let mockSchool = [mockSchool1()]
        let (sut, loader) = makeSut()
        sut.load()
        
        loader.completeWith(success: mockSchool)
        XCTAssertEqual(sut.currentState, .completed(mockSchool), "Expected Completed Loading state but found \(sut.currentState)")
    }
    
    private func makeSut() -> (sut: SchoolListViewModel, loader: MockLoader) {
        
        let loader = MockLoader()
        let sut = SchoolListViewModel(loader: loader)
        
        return (sut, loader)
    }

    private class MockLoader: SchoolLoader {
        
        private var messages: [(Result<[SchoolInfo], Error>) -> Void] = []
        
        func load(completion: @escaping (Result<[SchoolInfo], Error>) -> Void) {
            messages.append(completion)
        }
        
        func completeWith(error: Error, at index: Int = 0) {
            messages[index](.failure(error))
        }
        
        func completeWith(success schools: [SchoolInfo], at index: Int = 0) {
            messages[index](.success(schools))
        }
    }
}
