//
//  UserProfileResponse.swift
//  OnTheMap
//
//  Created by Maverick on 2022/1/10.
//

import Foundation

struct UserProfileResponse: Codable {
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
