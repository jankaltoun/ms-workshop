//
//  ProfileViewModelTests.swift
//  LamstagramTests
//
//  Created by Jan Kaltoun on 15/01/2020.
//  Copyright © 2020 Jan Kaltoun. All rights reserved.
//

import XCTest
@testable import Lamstagram

class ProfileViewModelTests: XCTestCase {
    class MockUserService: UserServicing {
        let shouldFail: Bool
        
        init(shouldFail: Bool) {
            self.shouldFail = shouldFail
        }
        
        func getUser(id: Int, completion: @escaping UserFetchCompletion) {
            guard !shouldFail else {
                completion(.failure(MockData.error))
                
                return
            }
            
            completion(.success(MockData.user))
        }
    }
    
    class MockProfileViewModelDelegate: ProfileViewModelDelegate {
        typealias Completion = () -> Void
        
        var viewModel: ProfileViewModel
        var expectation: XCTestExpectation
        var completion: Completion
        
        init(viewModel: ProfileViewModel, expectation: XCTestExpectation, completion: @escaping Completion) {
            self.viewModel = viewModel
            self.expectation = expectation
            self.completion = completion
        }
        
        func stateDidChange(previousState: State) {
            completion()
            
            expectation.fulfill()
        }
    }

    func testUserFetchSuccess() {
        let userService = MockUserService(shouldFail: false)
        let viewModel = ProfileViewModel(userService: userService)
        viewModel.userID = 1
        
        let fetchComplete = XCTestExpectation(description: "Wait for fetch")
        let delegate = MockProfileViewModelDelegate(viewModel: viewModel, expectation: fetchComplete) {
            switch viewModel.state {
            case .ready:
                break
            default:
                XCTFail("Unexpected ViewModel state. Should be `.ready`.")
            }
            
            XCTAssert(viewModel.user == MockData.user)
            
            XCTAssert(viewModel.user?.posts?.count == 2)
            XCTAssert(viewModel.getPost(for: 0) == MockData.user.posts!.first!)
            
            XCTAssert(viewModel.user?.friends?.count == 1)
            XCTAssert(viewModel.getFriend(for: 0) == MockData.user.friends!.first!)
            
            XCTAssert(viewModel.getSection(for: 0) == .profile)
            XCTAssert(viewModel.getSection(for: 1) == .friends)
            XCTAssert(viewModel.getSection(for: 2) == .photos)
        }
        viewModel.delegate = delegate
        
        viewModel.getUser()
        
        wait(for: [fetchComplete], timeout: 1)
    }
    
    func testUserFetchFailure() {
        let userService = MockUserService(shouldFail: true)
        let viewModel = ProfileViewModel(userService: userService)
        viewModel.userID = 1
        
        let fetchComplete = XCTestExpectation(description: "Wait for fetch")
        let delegate = MockProfileViewModelDelegate(viewModel: viewModel, expectation: fetchComplete) {
            switch viewModel.state {
            case .failed(let error):
                XCTAssert(error as! AppError == MockData.error)
            default:
                XCTFail("Unexpected ViewModel state. Should be `.failed`.")
            }
            
            XCTAssert(viewModel.user == nil)
            XCTAssert(viewModel.sections.count == 1)
            XCTAssert(viewModel.getSection(for: 0) == .profile)
        }
        viewModel.delegate = delegate
        
        viewModel.getUser()
        
        wait(for: [fetchComplete], timeout: 1)
    }
}

extension ProfileViewModelTests {
    enum MockData {
        static let user = User(
            id: 1,
            nickname: "johndoe",
            name: "John Doe",
            numberOfPosts: 1,
            numberOfFollowers: 2,
            numberFollowing: 3,
            description: "Some description.",
            posts: [
                Post(id: 1, user: nil),
                Post(id: 2, user: nil)
            ],
            friends: [
                User(
                    id: 1,
                    nickname: "janedoe",
                    name: "Jane Doe",
                    numberOfPosts: 4,
                    numberOfFollowers: 5,
                    numberFollowing: 6,
                    description: "Some other description.",
                    posts: [],
                    friends: []
                )
            ]
        )
        
        static let error = AppError.somethingWentReallyWrong
    }
}
