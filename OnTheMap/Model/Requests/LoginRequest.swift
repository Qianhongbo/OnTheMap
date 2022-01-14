//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Maverick on 2022/1/10.
//

import Foundation

struct LoginRequest: Codable {
    let udacity: udacityLoginBody
}

struct udacityLoginBody: Codable {
    let username: String
    let password: String
}
