//
//  TextFieldSetup.swift
//  ntucylsapp
//
//  Created by Yian Chen on 2020/9/16.
//  Copyright © 2020 Yian Chen. All rights reserved.
//

import Foundation
import UIKit

struct TextfieldSetup{
    static func defaultType(textfield: UITextField, view: UIView, placeholder: String){
        view.addSubview(textfield)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textfield.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        textfield.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textfield.layer.cornerRadius = 5
        textfield.layer.borderWidth = 2
        textfield.layer.borderColor = CGColor(srgbRed: 0.3, green: 0.3, blue: 0.3, alpha: 0.5)
        textfield.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        textfield.textColor = .black
        textfield.autocapitalizationType = .none
        
        // this line can change the color of the placeholder
        textfield.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        // these three lines below makes the textfield padding
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        textfield.leftView = paddingView;
        textfield.leftViewMode = .always;
    }
    
    static func defaultType(textfield: UITextField, view: UIView, oneview: UIView, placeholder: String){
        oneview.addSubview(textfield)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textfield.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        textfield.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textfield.layer.cornerRadius = 5
        textfield.layer.borderWidth = 2
        textfield.layer.borderColor = CGColor(srgbRed: 0.3, green: 0.3, blue: 0.3, alpha: 0.5)
        textfield.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        textfield.textColor = .black
        textfield.autocapitalizationType = .none
        
        // this line can change the color of the placeholder
        textfield.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        // these three lines below makes the textfield padding
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        textfield.leftView = paddingView;
        textfield.leftViewMode = .always;
    }
    
}


//add this to view controller to dismiss keyboard
//also need to add UITextFieldDelegate at the top
//also need to add textfield.delegate = self in override viewDidLoad()
/*
// for pressing return dismiss keyboard
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return false
}
 */
