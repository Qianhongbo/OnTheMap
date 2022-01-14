//
//  StudentLocations.swift
//  OnTheMap
//
//  Created by Maverick on 2022/1/9.
//

import Foundation

struct StudentLocations: Codable {
    let results: [student]
}

struct student: Codable {
    let createdAt: String?
    let firstName, lastName: String
    let latitude, longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String?
    let uniqueKey: String
    let updatedAt: String?
}
