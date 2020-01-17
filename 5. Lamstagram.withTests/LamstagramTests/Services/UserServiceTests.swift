//
//  UserServiceTests.swift
//  LamstagramTests
//
//  Created by Jan Kaltoun on 15/01/2020.
//  Copyright © 2020 Jan Kaltoun. All rights reserved.
//

import XCTest
@testable import Lamstagram

class UserServiceTests: XCTestCase {
    class MockAPIManager: APIManaging {
        let shouldFail: Bool
        
        init(shouldFail: Bool) {
            self.shouldFail = shouldFail
        }
        
        func request<T>(path: String, completion: @escaping (Result<T, AppError>) -> Void) where T : Decodable {
            guard !shouldFail else {
                completion(.failure(MockData.error))
                
                return
            }
            
            let user = MockData.users as! T
            
            completion(.success(user))
        }
    }

    func testUserFetchSuccess() {
        let apiManager = MockAPIManager(shouldFail: false)
        let userService = UserService(apiManager: apiManager)
        
        let fetchComplete = XCTestExpectation(description: "Wait for fetch")
        
        userService.getUser(id: 1) { result in
            switch result {
            case .failure(_):
                XCTFail("User fetch should not fail.")
            case .success(let user):
                XCTAssert(user == MockData.users.first!)
            }
            
            fetchComplete.fulfill()
        }
        
        wait(for: [fetchComplete], timeout: 1)
    }
    
    func testUserFetchFailure() {
        let apiManager = MockAPIManager(shouldFail: true)
        let userService = UserService(apiManager: apiManager)
        
        let fetchComplete = XCTestExpectation(description: "Wait for fetch")
        
        userService.getUser(id: 1) { result in
            switch result {
            case .failure(let error):
                XCTAssert(error == MockData.error)
            case .success(_):
                XCTFail("User fetch should not succeed.")
            }
            
            fetchComplete.fulfill()
        }
        
        wait(for: [fetchComplete], timeout: 1)
    }
}

extension UserServiceTests {
    enum MockData {
        static let users = [
            User(
                id: 1,
                nickname: "johndoe",
                name: "John Doe",
                numberOfPosts: 1,
                numberOfFollowers: 2,
                numberFollowing: 3,
                description: "Some description.",
                posts: [],
                friends: []
            )
        ]
        
        static let error = AppError.somethingWentReallyWrong
    }
}
