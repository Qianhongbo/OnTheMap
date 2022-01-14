//
//  UITextField+Extension.swift
//  OnTheMap
//
//  Created by Maverick on 2022/1/11.
//

import Foundation
import UIKit

extension UIViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
