//
//  AddPinViewController.swift
//  OnTheMap
//
//  Created by Maverick on 2022/1/9.
//

import Foundation
import UIKit
import MapKit

class AddPinViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func findOnTheMap(_ sender: Any) {
        self.activityIndicator.startAnimating()
        let location = self.textField.text
        CLGeocoder().geocodeAddressString(location ?? "") { mark, error in
            guard let mark = mark else {
                self.showAlertViewController(title: "Search Failed", message: "Can not find the location.")
                return
            }
            let result = mark.first?.location
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddWebsiteViewController") as! AddWebsiteViewController
            controller.location = result!.coordinate
            controller.address = self.textField.text
            self.activityIndicator.stopAnimating()
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}
    

