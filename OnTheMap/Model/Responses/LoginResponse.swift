//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Maverick on 2022/1/10.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}
