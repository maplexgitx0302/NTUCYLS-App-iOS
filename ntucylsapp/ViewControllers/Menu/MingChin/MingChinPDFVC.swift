//
//  MingChinPDFVC.swift
//  ntucylsapp
//
//  Created by Yian Chen on 2020/10/2.
//  Copyright © 2020 Yian Chen. All rights reserved.
//

import UIKit

class MingChinPDFVC: UIViewController, UIScrollViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colors.defaultUIColor()
        
        viewsetup()
        
        var count = 1
        while UIImage(named: "\(MingChinInfo.epochIndex)mingchin\(count)") != nil {
            let image = UIImage(named: "\(MingChinInfo.epochIndex)mingchin\(count)")
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            stackview.addArrangedSubview(imageView)
            let ratio = imageView.image!.size.height / imageView.image!.size.width
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.centerXAnchor.constraint(equalTo: stackview.centerXAnchor).isActive = true
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            imageView.heightAnchor.constraint(equalTo: stackview.widthAnchor, multiplier: ratio).isActive = true
            count += 1
        }
        
    }
    //***************************************************************************
    //******************************object_start*********************************
    //***************************************************************************
    
    private let scrollview = UIScrollView()
    private let stackview = UIStackView()
    
    func viewsetup(){
        view.addSubview(scrollview)
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        scrollview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollview.maximumZoomScale = 4.0
        scrollview.minimumZoomScale = 1
        scrollview.zoomScale = 1
        scrollview.delegate = self
        
        scrollview.addSubview(stackview)
        stackview.axis = .vertical
        stackview.spacing = 20
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.topAnchor.constraint(equalTo: scrollview.topAnchor).isActive = true
        stackview.bottomAnchor.constraint(equalTo: scrollview.bottomAnchor).isActive = true
        stackview.leadingAnchor.constraint(equalTo: scrollview.leadingAnchor).isActive = true
        stackview.trailingAnchor.constraint(equalTo: scrollview.trailingAnchor).isActive = true
    }

    //***************************************************************************
    //******************************object_end***********************************
    //***************************************************************************


    //***************************************************************************
    //******************************function_start*******************************
    //***************************************************************************
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return stackview
    }
    //***************************************************************************
    //******************************function_end*********************************
    //***************************************************************************
    
}
