//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by Maverick on 2022/1/9.
//

import Foundation
import UIKit

class UDacityAPI {
    
    struct Auth {
        static var userId = ""
        static var firstName = ""
        static var lastName = ""
        static var sessionId = ""
        static var objectId = ""
        static var cancelOrOverwrite = "cancel"
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        case logout
        case signUp
        case getPublicUserData
        case studentLocation
        case postStudentLocation
        case putStudentLocation
        
        var stringValue: String {
            switch self {
            case .login: return Endpoints.base + "/session"
            case .logout: return Endpoints.base + "/session"
            case .signUp: return "https://auth.udacity.com/sign-up"
            case .getPublicUserData: return Endpoints.base + "/users/" + Auth.userId
            case .studentLocation: return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
            case .postStudentLocation: return Endpoints.base + "/StudentLocation"
            case .putStudentLocation: return Endpoints.base + "/StudentLocation/" + Auth.objectId
            }
        }
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
    }
    
    //MARK: GET Request
    class func taskForGetRequest<ResponseType: Decodable>(url: URL, API: String, responseType: ResponseType.Type, completionHandler: @escaping (ResponseType?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                if API == "Udacity" {
                    let newData = data.subdata(in: 5..<data.count)
                    let responseObject = try decoder.decode(responseType, from: newData)
                    DispatchQueue.main.async {
                        completionHandler(responseObject, nil)
                    }
                } else {
                    let responseObject = try decoder.decode(responseType, from: data)
                    DispatchQueue.main.async {
                        completionHandler(responseObject, nil)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
        }
        task.resume()
    }
    
    //MARK: POST Request
    class func taskForPostRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, API: String, httpMethod: String, responseType: ResponseType.Type, body: RequestType, completionHandler: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        if API == "Udacity" {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } else {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                if API == "Udacity" {
                    let newData = data.subdata(in: 5..<data.count)
                    let responseObject = try decoder.decode(responseType, from: newData)
                    DispatchQueue.main.async {
                        completionHandler(responseObject, nil)
                    }
                } else {
                    let responseObject = try decoder.decode(responseType, from: data)
                    DispatchQueue.main.async {
                        completionHandler(responseObject, nil)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func login(username: String, password: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        let body = LoginRequest(udacity: udacityLoginBody(username: username, password: password))
        taskForPostRequest(url: Endpoints.login.url, API: "Udacity", httpMethod: "POST", responseType: LoginResponse.self, body: body) { response, error in
            if let response = response {
                self.Auth.userId = response.account.key
                self.Auth.sessionId = response.session.id
                getPublicUserData { success, error in
                    if success {
                        completionHandler(true, nil)
                    } else {
                        completionHandler(false, error)
                    }
                }
            } else {
                completionHandler(false, error)
            }
        }
    }
    
    class func getPublicUserData(completionHandler: @escaping (Bool, Error?) -> Void) {
        taskForGetRequest(url: Endpoints.getPublicUserData.url, API: "Udacity", responseType: PublicUserData.self) { response, error in
            if let response = response {
                self.Auth.firstName = response.firstName
                self.Auth.lastName = response.lastName
                completionHandler(true, nil)
            } else {
                completionHandler(false, error)
            }
        }
    }
    
    class func logout(completionHandler: @escaping () -> Void) {
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            }
            self.Auth.userId = ""
            self.Auth.firstName = ""
            self.Auth.lastName = ""
            self.Auth.sessionId = ""
            self.Auth.objectId = ""
            self.Auth.cancelOrOverwrite = "cancel"
            completionHandler()
        }
        task.resume()
    }
    
    class func getStudentLocations(completionHandler: @escaping ([student], Error?) -> Void) {
        taskForGetRequest(url: Endpoints.studentLocation.url, API: "Parse",responseType: StudentLocations.self) { response, error in
            if let response = response {
                completionHandler(response.results, nil)
            } else {
                completionHandler([], error)
            }
        }
    }
    
    class func postStudentLocation(locationData: LocationData, mediaURL: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        let body = createBody(locationData: locationData, mediaURL: mediaURL)
        taskForPostRequest(url: Endpoints.postStudentLocation.url, API: "Parse", httpMethod: "POST", responseType: PostStudentLocation.self, body: body) { response, error in
            if let response = response {
                Auth.objectId = response.objectId
                completionHandler(true, nil)
            } else {
                completionHandler(false, error)
            }
        }
    }
    
    class func putStudentLocation(locationData: LocationData, mediaURL: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        let body = createBody(locationData: locationData, mediaURL: mediaURL)
        taskForPostRequest(url: Endpoints.putStudentLocation.url, API: "Parse", httpMethod: "PUT", responseType: PutStudentLocation.self, body: body) { response, error in
            if response != nil {
                completionHandler(true, nil)
            } else {
                completionHandler(false, error)
            }
        }
    }
    
    class func createBody(locationData: LocationData, mediaURL: String) -> student {
        let body = student(
            createdAt: nil,
            firstName: self.Auth.firstName,
            lastName: self.Auth.lastName,
            latitude: locationData.coordinates.latitude,
            longitude: locationData.coordinates.longitude,
            mapString: locationData.address,
            mediaURL: mediaURL,
            objectId: nil,
            uniqueKey: self.Auth.userId,
            updatedAt: nil)
        return body
    }
    
}
