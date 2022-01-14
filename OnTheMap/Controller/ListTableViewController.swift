//
//  listViewController.swift
//  OnTheMap
//
//  Created by Maverick on 2022/1/9.
//

import Foundation
import UIKit

class ListTableViewController: UITableViewController {
    
    var locations: [student] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateStudentLocations()
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
                self.locations = Array(result[0..<100])
                self.tableView.reloadData()
            } else {
                self.showAlertViewController(title: "Load Data Failed", message: error?.localizedDescription ?? "")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell")!
        let data = self.locations[indexPath.row]
        cell.textLabel?.text = data.firstName + " " + data.lastName
        cell.detailTextLabel?.text = data.mediaURL
        cell.imageView?.image = UIImage(named: "icon_pin")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.locations[indexPath.row]
        if let url = URL(string: data.mediaURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}
