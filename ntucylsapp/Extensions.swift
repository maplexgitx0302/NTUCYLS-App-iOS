//
//  Extensions.swift
//  ntucylsapp
//
//  Created by Yian Chen on 2020/9/16.
//  Copyright © 2020 Yian Chen. All rights reserved.
//

import Foundation
import UIKit


//***************************************************************************
// This extension allows people to dismiss their keyboard when touch outside
// Notice one should add one code line: self.hideKeyboardWhenTappedAround()
// inside every UIViewController override ViewDidLoad
// ex:
/*
 override func viewDidLoad() {
     super.viewDidLoad()
     self.hideKeyboardWhenTappedAround()
 }
*/
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
//***************************************************************************

//***************************************************************************
// to add press return dismiss keyboard
// do like this
/*
 import UIKit

 class ViewController: UIViewController, UITextFieldDelegate {

     @IBOutlet var myTextField : UITextField

     override func viewDidLoad() {
         super.viewDidLoad()
         // Do any additional setup after loading the view, typically from a nib.

         self.myTextField.delegate = self
     }

     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         self.view.endEditing(true)
         return false
     }
 }
*/
//***************************************************************************
