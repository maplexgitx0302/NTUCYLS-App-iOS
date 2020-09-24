//
//  LoadingSpinner.swift
//  ntucylsapp
//
//  Created by Yian Chen on 2020/9/24.
//  Copyright © 2020 Yian Chen. All rights reserved.
//

import Foundation
import UIKit

class LoadingSpinner: UIView{
    let spinner = UIActivityIndicatorView()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup(){
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: 100).isActive = true
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        backgroundColor = .systemGray3
        alpha = 0
        layer.cornerRadius = 5
        
        addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        spinner.style = .large
        spinner.hidesWhenStopped = true
    }
    func startSpinning(){
        self.alpha = 0.75
        spinner.startAnimating()
    }
    func stopSpinning(){
        self.alpha = 0
        spinner.stopAnimating()
    }
    
}
