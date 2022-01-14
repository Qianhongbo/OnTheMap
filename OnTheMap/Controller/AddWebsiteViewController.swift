//
//  AddWebsiteViewController.swift
//  OnTheMap
//
//  Created by Maverick on 2022/1/10.
//

import Foundation
import UIKit
import MapKit

class AddWebsiteViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    var location: CLLocationCoordinate2D!
    var address: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.delegate = self
        self.mapView.delegate = self
        let annotation = MKPointAnnotation()
        annotation.coordinate = self.location
        self.mapView.addAnnotation(annotation)
        self.mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func postStudentLocation(_ sender: Any) {
        guard let location = self.location, let address = self.address else {
            self.showAlertViewController(title: "Location Error", message: "Can not find the location. Please try again.")
            return
        }
        guard let url = URL(string: self.textField.text ?? ""), UIApplication.shared.canOpenURL(url) else {
            self.showAlertViewController(title: "Invalid URL", message: "Can not open URL. Please include 'http://' in your link.")
            return
        }
        let locationData = LocationData(address: address, coordinates: location)
        if UDacityAPI.Auth.cancelOrOverwrite == "cancel" {
            UDacityAPI.postStudentLocation(locationData: locationData, mediaURL: self.textField.text ?? "") { success, error in
                if success {
                    self.popViewController()
                } else {
                    self.showAlertViewController(title: "Post Failed", message: "Post student location fail. Please try again.")
                }
            }
        } else {
            UDacityAPI.putStudentLocation(locationData: locationData, mediaURL: self.textField.text ?? "") { success, error in
                if success {
                    self.popViewController()
                } else {
                    self.showAlertViewController(title: "Put Failed", message: "Put student location fail. Please try again.")
                }
            }
        }
    }
    
    func popViewController() {
        if let viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            self.navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
        }
    }
    
}
