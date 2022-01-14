//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by Maverick on 2022/1/10.
//

import Foundation
import UIKit

extension UIViewController {
    
    func setNavigationButton() {
        let refreshItem =  UIBarButtonItem.init(
            image: UIImage(named: "icon_refresh"),
            style: .plain,
            target: self,
            action: #selector(self.refresh))
        
        let addpinItem = UIBarButtonItem.init(
            image: UIImage(named: "icon_addpin"),
            style: .plain,
            target: self,
            action: #selector(self.addPin))
        
        self.navigationItem.rightBarButtonItems = [refreshItem, addpinItem]
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(self.logout))
    }
    
    @objc func logout() {
        UDacityAPI.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func refresh() {}
    
    @objc func addPin() {
        let postStatus = UDacityAPI.Auth.objectId != ""
        if postStatus {
            let message = """
            You have already posted a student location.
            Would you like to overwrite your current location?
            """
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                self.handleAlertControllerResponse(cancelOrOverwrite: "cancel")
            }
            let okAction = UIAlertAction(title: "Overwrite", style: .default) { action in
                self.handleAlertControllerResponse(cancelOrOverwrite: "overwrite")
            }
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            self.showAddPinViewController()
        }
    }
    
    func handleAlertControllerResponse(cancelOrOverwrite: String) {
        UDacityAPI.Auth.cancelOrOverwrite = cancelOrOverwrite
        self.showAddPinViewController()
    }
    
    func showAddPinViewController() {
        if self.title == "MapViewController" {
            self.performSegue(withIdentifier: "addPinFromTheMap", sender: nil)
        } else {
            self.performSegue(withIdentifier: "addPinFromTheList", sender: nil)
        }
    }
    
}
