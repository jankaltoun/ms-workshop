//
//  PostServiceTests.swift
//  LamstagramTests
//
//  Created by Jan Kaltoun on 15/01/2020.
//  Copyright © 2020 Jan Kaltoun. All rights reserved.
//

import XCTest
@testable import Lamstagram

class PostServiceTests: XCTestCase {
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
            
            let user = MockData.posts as! T
            
            completion(.success(user))
        }
    }

    func testPostsFetchSuccess() {
        let apiManager = MockAPIManager(shouldFail: false)
        let postService = PostService(apiManager: apiManager)
        
        let fetchComplete = XCTestExpectation(description: "Wait for fetch")
        
        postService.getPosts() { result in
            switch result {
            case .failure(_):
                XCTFail("Post fetch should not fail.")
            case .success(let posts):
                XCTAssert(posts.count == 2)
            }
            
            fetchComplete.fulfill()
        }
        
        wait(for: [fetchComplete], timeout: 1)
    }
    
    func testPostsFetchFailure() {
        let apiManager = MockAPIManager(shouldFail: true)
        let userService = PostService(apiManager: apiManager)
        
        let fetchComplete = XCTestExpectation(description: "Wait for fetch")
        
        userService.getPosts() { result in
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

extension PostServiceTests {
    enum MockData {
        static let posts = [
            Post(id: 1, user: nil),
            Post(id: 2, user: nil)
        ]
        
        static let error = AppError.somethingWentReallyWrong
    }
}
