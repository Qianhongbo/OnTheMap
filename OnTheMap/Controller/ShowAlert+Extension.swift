//
//  ShowAlert+Extension.swift
//  OnTheMap
//
//  Created by Maverick on 2022/1/12.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlertViewController(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
