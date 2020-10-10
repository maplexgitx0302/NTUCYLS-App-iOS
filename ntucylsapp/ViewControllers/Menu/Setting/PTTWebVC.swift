//
//  PTTWebVC.swift
//  ntucylsapp
//
//  Created by Yian Chen on 2020/10/1.
//  Copyright © 2020 Yian Chen. All rights reserved.
//

import UIKit
import WebKit

class PTTWebVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colors.defaultUIColor()

        let webView = WKWebView()
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        let ntucylsPTTURL = URL(string: "https://www.ptt.cc/man/ntucyls/index.html")
        let request = URLRequest(url: ntucylsPTTURL!)
        
        webView.load(request)
    }
}
