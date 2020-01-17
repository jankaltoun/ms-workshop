//
//  FeedViewModelTests.swift
//  LamstagramTests
//
//  Created by Jan Kaltoun on 15/01/2020.
//  Copyright © 2020 Jan Kaltoun. All rights reserved.
//

import XCTest
@testable import Lamstagram

class FeedViewModelTests: XCTestCase {
    class MockPostService: PostServicing {
        let shouldFail: Bool
        
        init(shouldFail: Bool) {
            self.shouldFail = shouldFail
        }
        
        func getPosts(completion: @escaping PostFetchCompletion) {
            guard !shouldFail else {
                completion(.failure(MockData.error))
                
                return
            }
            
            completion(.success(MockData.posts))
        }
    }
    
    class MockFeedViewModelDelegate: FeedViewModelDelegate {
        typealias Completion = () -> Void
        
        var viewModel: FeedViewModel
        var expectation: XCTestExpectation
        var completion: Completion
        
        init(viewModel: FeedViewModel, expectation: XCTestExpectation, completion: @escaping Completion) {
            self.viewModel = viewModel
            self.expectation = expectation
            self.completion = completion
        }
        
        func stateDidChange(previousState: State) {
            completion()
            
            expectation.fulfill()
        }
    }

    func testPostsFetchSuccess() {
        let postService = MockPostService(shouldFail: false)
        let viewModel = FeedViewModel(postService: postService)
        
        let fetchComplete = XCTestExpectation(description: "Wait for fetch")
        let delegate = MockFeedViewModelDelegate(viewModel: viewModel, expectation: fetchComplete) {
            switch viewModel.state {
            case .ready:
                break
            default:
                XCTFail("Unexpected ViewModel state. Should be `.ready`.")
            }
            
            XCTAssert(viewModel.posts.count == 2)
            XCTAssert(viewModel.getPost(for: 0) == MockData.posts.first!)
        }
        viewModel.delegate = delegate
        
        viewModel.getPosts()
        
        wait(for: [fetchComplete], timeout: 1)
    }
    
    func testPostsFetchFailure() {
        let postService = MockPostService(shouldFail: true)
        let viewModel = FeedViewModel(postService: postService)
        
        let fetchComplete = XCTestExpectation(description: "Wait for fetch")
        let delegate = MockFeedViewModelDelegate(viewModel: viewModel, expectation: fetchComplete) {
            switch viewModel.state {
            case .failed(let error):
                XCTAssert(error as! AppError == MockData.error)
            default:
                XCTFail("Unexpected ViewModel state. Should be `.failed`.")
            }
            
            XCTAssert(viewModel.posts.count == 0)
        }
        viewModel.delegate = delegate
        
        viewModel.getPosts()
        
        wait(for: [fetchComplete], timeout: 1)
    }
}

extension FeedViewModelTests {
    enum MockData {
        static let posts = [
            Post(id: 1, user: nil),
            Post(id: 2, user: nil)
        ]
        
        static let error = AppError.somethingWentReallyWrong
    }
}
