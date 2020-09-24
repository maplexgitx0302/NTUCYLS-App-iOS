//
//  Buttons.swift
//  ntucylsapp
//
//  Created by Yian Chen on 2020/9/15.
//  Copyright © 2020 Yian Chen. All rights reserved.
//

import Foundation
import UIKit

struct ButtonSetup{
    static func loginButton(button: UIButton, view: UIView, text: String){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.35).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont(name: "DFChu-W4-WIN-BF", size: 25)
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.baselineAdjustment = .alignCenters
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitle(text, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
    }
}
