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
    
    var annotations = [MKPointAnnotation]()
    var postStatus: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.setNavigationButton()
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
        mapView.removeAnnotations(mapView.annotations)
        self.annotations = []
        UDacityAPI.getStudentLocations { result, error in
            if error == nil {
                StudentLocationsModel.studentLocations = result
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
        for dictionary in StudentLocationsModel.studentLocations {
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
