//
//  listViewController.swift
//  OnTheMap
//
//  Created by Maverick on 2022/1/9.
//

import Foundation
import UIKit

class ListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateStudentLocations()
    }
    
    override func refresh() {
        self.updateStudentLocations()
    }
    
    func updateStudentLocations() {
        UDacityAPI.getStudentLocations { result, error in
            if error == nil {
                StudentLocationsModel.studentLocations = result
                self.tableView.reloadData()
            } else {
                self.showAlertViewController(title: "Load Data Failed", message: error?.localizedDescription ?? "")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocationsModel.studentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell")!
        let data = StudentLocationsModel.studentLocations[indexPath.row]
        cell.textLabel?.text = data.firstName + " " + data.lastName
        cell.detailTextLabel?.text = data.mediaURL
        cell.imageView?.image = UIImage(named: "icon_pin")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = StudentLocationsModel.studentLocations[indexPath.row]
        if let url = URL(string: data.mediaURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}
