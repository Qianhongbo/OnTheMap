//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Maverick on 2022/1/8.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var locations: [student] = []
    var annotations = [MKPointAnnotation]()
    var postStatus: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.setNavigationButton()
        self.updateStudentLocations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.activityIndicator.startAnimating()
        self.updateStudentLocations()
    }
    
    override func refresh() {
        self.activityIndicator.startAnimating()
        self.updateStudentLocations()
    }
    
    func updateStudentLocations() {
        UDacityAPI.getStudentLocations { result, error in
            if error == nil {
                self.locations = Array(result[0..<100])
                self.createAnnotations()
                self.mapView.addAnnotations(self.annotations)
                self.activityIndicator.stopAnimating()
            } else {
                self.activityIndicator.stopAnimating()
                self.showAlertViewController(title: "Load Data Failed", message: error?.localizedDescription ?? "")
            }
        }
    }
    
    func createAnnotations() {
        for dictionary in self.locations {
            let latitude = CLLocationDegrees(dictionary.latitude)
            let longitude = CLLocationDegrees(dictionary.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let firstName = dictionary.firstName
            let lastName = dictionary.lastName
            let mediaURL = dictionary.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = firstName + " " + lastName
            annotation.subtitle = mediaURL
            
            self.annotations.append(annotation)
        }
    }
    
}
