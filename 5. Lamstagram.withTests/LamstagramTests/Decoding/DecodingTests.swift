//
//  LamstagramTests.swift
//  LamstagramTests
//
//  Created by Jan Kaltoun on 12/01/2020.
//  Copyright © 2020 Jan Kaltoun. All rights reserved.
//

import XCTest
@testable import Lamstagram

class DecodingTests: XCTestCase {
    let jsonDecoder = JSONDecoder()

    func testUserListDecoding() {
        let data = MockData.users.data(using: .utf8)!
        let users = try! jsonDecoder.decode([User].self, from: data)
        
        XCTAssert(users.count == 4)
        XCTAssert(users.first?.id == 1)
    }
    
    func testUserDecoding() {
        let data = MockData.user.data(using: .utf8)!
        let user = try! jsonDecoder.decode(User.self, from: data)
        
        XCTAssert(user.id == 1)
        XCTAssert(user.nickname == "barallama")
        XCTAssert(user.name == "Barack O. Llama")
        XCTAssert(user.numberOfPosts == 42)
        XCTAssert(user.numberOfFollowers == 596)
        XCTAssert(user.numberFollowing == 346)
        XCTAssert(user.description == "Lorem ipsum dolor sit amet, consectetur adipiscing elit 📯. Nam vulputate urna sit amet sodales interdum 🍒. Proin lobortis luctus elit quis venenatis 💨. Donec et leo mauris 💔.")
        XCTAssert(user.posts?.count == 3)
        XCTAssert(user.posts?.first?.id == 1)
        XCTAssert(user.friends?.count == 2)
        XCTAssert(user.friends?.first?.id == 2)
    }
    
    func testPostsDecoding() {
        let data = MockData.posts.data(using: .utf8)!
        let posts = try! jsonDecoder.decode([Post].self, from: data)
        
        XCTAssert(posts.count == 2)
        XCTAssert(posts.first?.id == 1)
    }
    
    func testPostDecoding() {
        let data = MockData.post.data(using: .utf8)!
        let post = try! jsonDecoder.decode(Post.self, from: data)
        
        XCTAssert(post.id == 1)
        XCTAssert(post.user?.id == 1)
    }
}

extension DecodingTests {
    enum MockData {
        static let users = """
            [
                {
                    "id": 1,
                    "nickname": "barallama",
                    "name": "Barack O. Llama",
                    "numberOfPosts": 42,
                    "numberOfFollowers": 596,
                    "numberFollowing": 346,
                    "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit 📯. Nam vulputate urna sit amet sodales interdum 🍒. Proin lobortis luctus elit quis venenatis 💨. Donec et leo mauris 💔.",
                    "posts": [
                        {
                            "id": 1
                        },
                        {
                            "id": 3
                        },
                        {
                            "id": 5
                        }
                    ],
                    "friends": [
                        {
                            "id": 2,
                            "nickname": "llama_dalai",
                            "name": "Dalai Llama",
                            "numberOfPosts": 14,
                            "numberOfFollowers": 3,
                            "numberFollowing": 12,
                            "description": "Praesent condimentum urna a ex lacinia tristique 🎰. Quisque non justo turpis 🐫. Duis pharetra lobortis odio, in dapibus mauris mollis sit amet 📈."
                        },
                        {
                            "id": 3,
                            "nickname": "dolly",
                            "name": "Dolly Llama",
                            "numberOfPosts": 42,
                            "numberOfFollowers": 596,
                            "numberFollowing": 346,
                            "description": "Sed nisi odio, commodo ut euismod sed, aliquet blandit urna 🐠. Duis vitae aliquam justo 🌖. Fusce luctus massa nibh, a porta purus iaculis non. Vestibulum vel tincidunt eros 💾."
                        }
                    ]
                },
                {
                    "id": 2,
                    "nickname": "llama_dalai",
                    "name": "Dalai Llama",
                    "numberOfPosts": 14,
                    "numberOfFollowers": 3,
                    "numberFollowing": 12,
                    "description": "Praesent condimentum urna a ex lacinia tristique 🎰. Quisque non justo turpis 🐫. Duis pharetra lobortis odio, in dapibus mauris mollis sit amet 📈.",
                    "posts": [
                        {
                            "id": 4
                        },
                        {
                            "id": 10
                        }
                    ]

                },
                {
                    "id": 3,
                    "nickname": "dolly",
                    "name": "Dolly Llama",
                    "numberOfPosts": 42,
                    "numberOfFollowers": 596,
                    "numberFollowing": 346,
                    "description": "Sed nisi odio, commodo ut euismod sed, aliquet blandit urna 🐠. Duis vitae aliquam justo 🌖. Fusce luctus massa nibh, a porta purus iaculis non. Vestibulum vel tincidunt eros 💾.",
                    "posts": [
                        {
                            "id": 6,
                            "userID": 3
                        },
                        {
                            "id": 9,
                            "userID": 3
                        }
                    ]

                },
                {
                    "id": 4,
                    "nickname": "shama_l",
                    "name": "Shama Llama",
                    "numberOfPosts": 513,
                    "numberOfFollowers": 871,
                    "numberFollowing": 66,
                    "description": "Nulla urna massa, vestibulum in efficitur ac, cursus ac sem 🌀. Sed euismod ligula suscipit arcu placerat finibus 💋. Curabitur at aliquet turpis 🌲. Pellentesque condimentum fringilla quam ac efficitur 🎅.",
                    "posts": [
                        {
                            "id": 2
                        }
                    ]

                }
            ]
        """
        
        static let user = """
            {
                "id": 1,
                "nickname": "barallama",
                "name": "Barack O. Llama",
                "numberOfPosts": 42,
                "numberOfFollowers": 596,
                "numberFollowing": 346,
                "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit 📯. Nam vulputate urna sit amet sodales interdum 🍒. Proin lobortis luctus elit quis venenatis 💨. Donec et leo mauris 💔.",
                "posts": [
                    {
                        "id": 1
                    },
                    {
                        "id": 3
                    },
                    {
                        "id": 5
                    }
                ],
                "friends": [
                    {
                        "id": 2,
                        "nickname": "llama_dalai",
                        "name": "Dalai Llama",
                        "numberOfPosts": 14,
                        "numberOfFollowers": 3,
                        "numberFollowing": 12,
                        "description": "Praesent condimentum urna a ex lacinia tristique 🎰. Quisque non justo turpis 🐫. Duis pharetra lobortis odio, in dapibus mauris mollis sit amet 📈."
                    },
                    {
                        "id": 3,
                        "nickname": "dolly",
                        "name": "Dolly Llama",
                        "numberOfPosts": 42,
                        "numberOfFollowers": 596,
                        "numberFollowing": 346,
                        "description": "Sed nisi odio, commodo ut euismod sed, aliquet blandit urna 🐠. Duis vitae aliquam justo 🌖. Fusce luctus massa nibh, a porta purus iaculis non. Vestibulum vel tincidunt eros 💾."
                    }
                ]
            }
        """
        
        static let posts = """
            [
                {
                    "id": 1,
                    "user": {
                        "id": 1,
                        "nickname": "barallama",
                        "name": "Barack O. Llama",
                        "numberOfPosts": 42,
                        "numberOfFollowers": 596,
                        "numberFollowing": 346,
                        "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit 📯. Nam vulputate urna sit amet sodales interdum 🍒. Proin lobortis luctus elit quis venenatis 💨. Donec et leo mauris 💔."
                    }
                },
                {
                    "id": 2,
                    "user": {
                        "id": 4,
                        "nickname": "shama_l",
                        "name": "Shama Llama",
                        "numberOfPosts": 513,
                        "numberOfFollowers": 871,
                        "numberFollowing": 66,
                        "description": "Nulla urna massa, vestibulum in efficitur ac, cursus ac sem 🌀. Sed euismod ligula suscipit arcu placerat finibus 💋. Curabitur at aliquet turpis 🌲. Pellentesque condimentum fringilla quam ac efficitur 🎅."
                    }
                }
            ]
        """
        
        static let post = """
            {
                "id": 1,
                "user": {
                    "id": 1,
                    "nickname": "barallama",
                    "name": "Barack O. Llama",
                    "numberOfPosts": 42,
                    "numberOfFollowers": 596,
                    "numberFollowing": 346,
                    "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit 📯. Nam vulputate urna sit amet sodales interdum 🍒. Proin lobortis luctus elit quis venenatis 💨. Donec et leo mauris 💔."
                }
            }
        """
    }
}
