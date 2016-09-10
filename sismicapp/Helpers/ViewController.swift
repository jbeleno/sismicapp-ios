//
//  ViewController.swift
//  sismicapp
//
//  Created by Juan Beleño Díaz on 9/09/16.
//  Copyright © 2016 Juan Beleño Díaz. All rights reserved.
//

import UIKit

// Code original done in http://stackoverflow.com/a/27079103
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}