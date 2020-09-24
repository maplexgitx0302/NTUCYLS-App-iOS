//
//  Colors.swift
//  ntucylsapp
//
//  Created by Yian Chen on 2020/9/17.
//  Copyright © 2020 Yian Chen. All rights reserved.
//

import Foundation
import UIKit

struct colors{
    //default RGB
    static var defaultRed: CGFloat = (UserDefaults.standard.object(forKey: "red") as? CGFloat) ?? 41
    static var defaultGreen: CGFloat = (UserDefaults.standard.object(forKey: "green") as? CGFloat) ?? 64
    static var defaultBlue: CGFloat = (UserDefaults.standard.object(forKey: "blue") as? CGFloat) ?? 104
    static var defaultLightRed: CGFloat = (UserDefaults.standard.object(forKey: "lightred") as? CGFloat) ?? 82
    static var defaultLightGreen: CGFloat = (UserDefaults.standard.object(forKey: "lightgreen") as? CGFloat) ?? 128
    static var defaultLightBlue: CGFloat = (UserDefaults.standard.object(forKey: "lightblue") as? CGFloat) ?? 208
    
    //default uicolors and cgcolors
    static func defaultUIColor()->UIColor{
        return UIcolor(r: colors.defaultRed, g: colors.defaultGreen, b: colors.defaultBlue, alpha: 1)
    }
    static func defaultCGColor()->CGColor{
        CGcolor(r: colors.defaultRed, g: colors.defaultGreen, b: colors.defaultBlue, alpha: 1)
    }
    static func defaultLightUIColor()->UIColor{
        UIcolor(r: colors.defaultLightRed, g: colors.defaultLightGreen, b: colors.defaultLightBlue, alpha: 1)
    }
    static func defaultLightCGColor()->CGColor{
        CGColor(srgbRed: colors.defaultLightRed, green: colors.defaultLightGreen, blue: colors.defaultLightBlue, alpha: 1)
    }
    
    //color funcs
    static func UIcolor(r:CGFloat, g:CGFloat, b:CGFloat, alpha:CGFloat)->UIColor{
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: alpha)
    }
    static func CGcolor(r:CGFloat, g:CGFloat, b:CGFloat, alpha:CGFloat)->CGColor{
        return CGColor(srgbRed: r/255, green: g/255, blue: b/255, alpha: alpha)
    }
    
    //change color
    static func ChangeDefaultColor(_sender: ColorButton, r: CGFloat, g: CGFloat, b: CGFloat, lr: CGFloat, lg: CGFloat, lb: CGFloat){
        
        colors.defaultRed = r
        colors.defaultGreen = g
        colors.defaultBlue = b
        colors.defaultLightRed = lr
        colors.defaultLightGreen = lg
        colors.defaultLightBlue = lb
        
        localstore.set(_sender.r, forKey: "red")
        localstore.set(_sender.g, forKey: "green")
        localstore.set(_sender.b, forKey: "blue")
        localstore.set(_sender.lr, forKey: "lightred")
        localstore.set(_sender.lg, forKey: "lightgreen")
        localstore.set(_sender.lb, forKey: "lightblue")
    }
}
