//
//  SettingVC.swift
//  ntucylsapp
//
//  Created by Yian Chen on 2020/9/17.
//  Copyright © 2020 Yian Chen. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colors.defaultUIColor()
        
        // set out the center block
        view.addSubview(centerBlock)
        centerBlock.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3).isActive = true
        centerBlock.heightAnchor.constraint(equalTo: centerBlock.widthAnchor).isActive = true
        centerBlock.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerBlock.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        // set out all blocks
        let block11 = settingBlock(title: "個人資料", iconName: "", performSegueTo: "PersonalInfoVC")
        let block12 = settingBlock(title: "主題顏色", iconName: "", performSegueTo: "ColorVC")
        let block13 = settingBlock(title: "登出", iconName: "", performSegueTo: "LogOut")
        let block21 = settingBlock(title: "21", iconName: "", performSegueTo: "")
        let block23 = settingBlock(title: "23", iconName: "", performSegueTo: "")
        let block31 = settingBlock(title: "31", iconName: "", performSegueTo: "")
        let block32 = settingBlock(title: "32", iconName: "", performSegueTo: "")
        let block33 = settingBlock(title: "33", iconName: "", performSegueTo: "")
        ThreeByThreeBLocks(b11: block11, b12: block12, b13: block13, b21: block21, b23: block23, b31: block31, b32: block32, b33: block33, center: centerBlock)
        
        // add target
    }
    
    //***************************************************************************
    //******************************object_start*********************************
    //***************************************************************************
    
    private let centerBlock: UIButton = {
        let block = UIButton()
        block.translatesAutoresizingMaskIntoConstraints = false
        block.layer.borderColor = colors.defaultLightCGColor()
        block.backgroundColor = colors.defaultUIColor()
        block.layer.borderWidth = 0.4
        block.setImage(UIImage(named: "cyls_icon"), for: .normal)
        block.imageView?.contentMode = .scaleAspectFit
        return block
    }()
    
    //***************************************************************************
    //******************************object_end***********************************
    //***************************************************************************
    
    //***************************************************************************
    //******************************function_start*******************************
    //***************************************************************************
    
    @objc func blockTouched(_sender: blockButton){
        if _sender.performSegueTo == "LogOut"{
            Alerts.logoutAlert(title: "確定要登出嗎？", message: "Are you sure to log out?", UIvc: self)
        }else if _sender.performSegueTo == ""{
            Alerts.defaultAlert(title: "尚未開放", message: "Not Available", UIvc: self)
        }else{
            performSegue(withIdentifier: _sender.performSegueTo!, sender: self)
        }
    }
    
    func settingBlock(title: String, iconName: String, performSegueTo: String)->blockButton{
        
        let button = blockButton()
        button.performSegueTo = performSegueTo
        button.addTarget(self, action: #selector(blockTouched(_sender:)), for: .touchUpInside)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.layer.borderWidth = 0.4
        button.layer.borderColor = colors.defaultLightCGColor()
        button.backgroundColor = colors.defaultUIColor()
        
        let icon = UIImageView()
        button.addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.widthAnchor.constraint(equalTo: button.widthAnchor, multiplier: 0.65).isActive = true
        icon.heightAnchor.constraint(equalTo: icon.widthAnchor).isActive = true
        icon.topAnchor.constraint(equalTo: button.topAnchor, constant: 5).isActive = true
        icon.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        if iconName != ""{
            icon.image = UIImage(named: iconName)
        }
        icon.contentMode = .scaleAspectFit
        
        let label = UILabel()
        button.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "DFFangSong-W6-WIN-BF", size: 15)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.baselineAdjustment = .alignCenters
        label.text = title
        label.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 5).isActive = true
        label.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -5).isActive = true
        label.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: button.widthAnchor, multiplier: 0.95).isActive = true
        return button
    }
    
    //***************************************************************************
    //******************************function_end*********************************
    //***************************************************************************
}


//set out all the locations
func ThreeByThreeBLocks(b11: UIButton, b12: UIButton, b13: UIButton, b21: UIButton, b23: UIButton, b31: UIButton, b32: UIButton, b33: UIButton, center: UIButton){
    
    b12.centerXAnchor.constraint(equalTo: center.centerXAnchor).isActive = true
    b12.bottomAnchor.constraint(equalTo: center.topAnchor).isActive = true
    
    b21.centerYAnchor.constraint(equalTo: center.centerYAnchor).isActive = true
    b21.trailingAnchor.constraint(equalTo: center.leadingAnchor).isActive = true
    
    b23.centerYAnchor.constraint(equalTo: center.centerYAnchor).isActive = true
    b23.leadingAnchor.constraint(equalTo: center.trailingAnchor).isActive = true
    
    b32.centerXAnchor.constraint(equalTo: center.centerXAnchor).isActive = true
    b32.topAnchor.constraint(equalTo: center.bottomAnchor).isActive = true
    
    b11.trailingAnchor.constraint(equalTo: b12.leadingAnchor).isActive = true
    b11.bottomAnchor.constraint(equalTo: b21.topAnchor).isActive = true
    
    b13.leadingAnchor.constraint(equalTo: b12.trailingAnchor).isActive = true
    b13.bottomAnchor.constraint(equalTo: b23.topAnchor).isActive = true
    
    b31.topAnchor.constraint(equalTo: b21.bottomAnchor).isActive = true
    b31.trailingAnchor.constraint(equalTo: b32.leadingAnchor).isActive = true
    
    b33.topAnchor.constraint(equalTo: b23.bottomAnchor).isActive = true
    b33.leadingAnchor.constraint(equalTo: b32.trailingAnchor).isActive = true
}


// to add some feature of UIButton
class blockButton: UIButton{
    var performSegueTo: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
}
