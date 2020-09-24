//
//  Alert.swift
//  ntucylsapp
//
//  Created by Yian Chen on 2020/9/16.
//  Copyright © 2020 Yian Chen. All rights reserved.
//

import Foundation
import UIKit

struct Alerts{
    // default alert for just notify
    static func defaultAlert(title: String, message: String, UIvc: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        UIvc.present(alert, animated: true, completion: nil)
    }
    
    // alert for double check
    static func logoutAlert(title: String, message: String, UIvc: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: {UIAlertAction in
            //change view to sign in view
            let directView = UIvc.storyboard?.instantiateViewController(identifier: "LoginVC") as? LoginVC
            UIvc.view.window?.rootViewController = directView
            UIvc.view.window?.makeKeyAndVisible()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        UIvc.present(alert, animated: true, completion: nil)
    }
}
