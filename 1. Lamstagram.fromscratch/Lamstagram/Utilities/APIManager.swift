//
//  APIManager.swift
//  Lamstagram
//
//  Created by Jan Kaltoun on 12/01/2020.
//  Copyright © 2020 Jan Kaltoun. All rights reserved.
//

import Foundation

class APIManager {
    typealias Completion = (Data) -> Void
    
    static let current = APIManager()
    
    func request(path: String, completion: @escaping Completion) {
        let url = Bundle.main.url(forResource: path, withExtension: "json")!
        
        let data = try! Data(contentsOf: url)
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            completion(data)
        }
    }
}
