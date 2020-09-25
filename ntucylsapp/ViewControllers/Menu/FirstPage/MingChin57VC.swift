//
//  FirstPageVC.swift
//  ntucylsapp
//
//  Created by Yian Chen on 2020/9/17.
//  Copyright © 2020 Yian Chen. All rights reserved.
//

import UIKit

class MingChin57VC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colors.defaultUIColor()
        
        //setup all views for scrollview contentview stackview
        viewSetup()
        
        
        //set up ming chin
        for i in 1...61{
            let newImageView = UIImageView()
            stackview.addArrangedSubview(newImageView)
            newImageView.translatesAutoresizingMaskIntoConstraints = false
            let imageNameString = "mingchin_compressed \(i)"
            newImageView.image = UIImage(named: imageNameString)
            newImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
            newImageView.heightAnchor.constraint(equalTo: stackview.heightAnchor).isActive = true
            newImageView.contentMode = .scaleAspectFit
            newImageView.widthAnchor.constraint(equalTo: newImageView.heightAnchor, multiplier: 8/(10.68)).isActive = true
            if i == 61{
                newImageView.trailingAnchor.constraint(equalTo: newImageView.trailingAnchor).isActive = true
            }
        }
        
    }
    
    //***************************************************************************
    //******************************object_start*********************************
    //***************************************************************************
    
    private let scrollview = UIScrollView()
    private let contentview = UIView()
    private let stackview = UIStackView()
    private let label = UILabel()
    
    func viewSetup(){
        view.addSubview(scrollview)
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        scrollview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollview.alwaysBounceHorizontal = true
        
        scrollview.addSubview(contentview)
        contentview.translatesAutoresizingMaskIntoConstraints = false
        contentview.topAnchor.constraint(equalTo: scrollview.topAnchor).isActive = true
        contentview.bottomAnchor.constraint(equalTo: scrollview.bottomAnchor).isActive = true
        contentview.leadingAnchor.constraint(equalTo: scrollview.leadingAnchor).isActive = true
        contentview.trailingAnchor.constraint(equalTo: scrollview.trailingAnchor).isActive = true
        contentview.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
        let widthconstraint = contentview.widthAnchor.constraint(equalTo: view.widthAnchor)
        widthconstraint.priority = .defaultLow
        widthconstraint.isActive = true
        
        contentview.addSubview(stackview)
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.topAnchor.constraint(equalTo: contentview.topAnchor).isActive = true
        stackview.bottomAnchor.constraint(equalTo: contentview.bottomAnchor).isActive = true
        stackview.leadingAnchor.constraint(equalTo: contentview.leadingAnchor).isActive = true
        stackview.trailingAnchor.constraint(equalTo: contentview.trailingAnchor).isActive = true
        stackview.spacing = 2
        stackview.axis = .horizontal
    }

    //***************************************************************************
    //******************************object_end***********************************
    //***************************************************************************


    //***************************************************************************
    //******************************function_start*******************************
    //***************************************************************************

    //***************************************************************************
    //******************************function_end*********************************
    //***************************************************************************
    
}
