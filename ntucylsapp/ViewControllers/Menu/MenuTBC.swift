//
//  MenuTBC.swift
//  ntucylsapp
//
//  Created by Yian Chen on 2020/9/16.
//  Copyright © 2020 Yian Chen. All rights reserved.
//

import UIKit

class MenuTBC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = colors.defaultLightUIColor()
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .systemGray3
        tabBar.contentMode = .scaleAspectFit
    }

}
