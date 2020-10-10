//
//  BlockVC.swift
//  ntucylsapp
//
//  Created by Yian Chen on 2020/10/4.
//  Copyright © 2020 Yian Chen. All rights reserved.
//

import UIKit
import Firebase

class BlockVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colors.defaultUIColor()
        viewsSetup()
        for key in FriendLocalDefault.blockDictionary.keys{
            let newview = UIView()
            newview.translatesAutoresizingMaskIntoConstraints = false
            stackview.addArrangedSubview(newview)
            //newview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            newview.heightAnchor.constraint(equalToConstant: 50).isActive = true
            newview.backgroundColor = colors.defaultLightUIColor()
            
            let IDLabel = UILabel()
            IDLabel.translatesAutoresizingMaskIntoConstraints = false
            newview.addSubview(IDLabel)
            IDLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
            IDLabel.topAnchor.constraint(equalTo: newview.topAnchor).isActive = true
            IDLabel.leadingAnchor.constraint(equalTo: newview.leadingAnchor,constant: 5).isActive = true
            IDLabel.heightAnchor.constraint(equalTo: newview.heightAnchor).isActive = true
            IDLabel.text = key + "  " + (FriendLocalDefault.blockDictionary[key] as! String)
            IDLabel.font = UIFont(name: "DFChu-W4-WIN-BF", size: 20)
            IDLabel.baselineAdjustment = .alignCenters
            IDLabel.adjustsFontSizeToFitWidth = true
            IDLabel.numberOfLines = 1
            IDLabel.textColor = .white
            
            let unblockDeleteButton = BlockButton()
            unblockDeleteButton.id = key
            newview.addSubview(unblockDeleteButton)
            unblockDeleteButton.translatesAutoresizingMaskIntoConstraints = false
            unblockDeleteButton.heightAnchor.constraint(equalTo: newview.heightAnchor, multiplier: 0.9).isActive = true
            unblockDeleteButton.centerYAnchor.constraint(equalTo: newview.centerYAnchor).isActive = true
            unblockDeleteButton.leadingAnchor.constraint(equalTo: IDLabel.trailingAnchor, constant: 5).isActive = true
            unblockDeleteButton.trailingAnchor.constraint(equalTo: newview.trailingAnchor, constant: -5).isActive = true
            unblockDeleteButton.layer.cornerRadius = 5
            unblockDeleteButton.backgroundColor = colors.defaultUIColor()
            unblockDeleteButton.setTitle("解封/刪除", for: .normal)
            unblockDeleteButton.setTitleColor(.white, for: .normal)
            unblockDeleteButton.titleLabel?.font = UIFont(name: "DFFangSong-W6-WIN-BF", size: 15)
            unblockDeleteButton.addTarget(self, action: #selector(buttonTouched(_sender:)), for: .touchUpInside)
        }
    }
    
    //***************************************************************************
    //******************************object_start*********************************
    //***************************************************************************
    private let scrollview = UIScrollView()
    private let contentview = UIView()
    private var stackview = UIStackView()
    func viewsSetup(){
        view.addSubview(scrollview)
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        scrollview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollview.alwaysBounceVertical = true
        
        scrollview.addSubview(contentview)
        contentview.translatesAutoresizingMaskIntoConstraints = false
        contentview.topAnchor.constraint(equalTo: scrollview.topAnchor).isActive = true
        contentview.bottomAnchor.constraint(equalTo: scrollview.bottomAnchor).isActive = true
        contentview.leadingAnchor.constraint(equalTo: scrollview.leadingAnchor).isActive = true
        contentview.trailingAnchor.constraint(equalTo: scrollview.trailingAnchor).isActive = true
        contentview.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        let heightConstraint = contentview.heightAnchor.constraint(equalTo: view.heightAnchor)
        heightConstraint.isActive = true
        heightConstraint.priority = .defaultLow
        
        contentview.addSubview(stackview)
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.topAnchor.constraint(equalTo: contentview.topAnchor).isActive = true
        stackview.bottomAnchor.constraint(equalTo: contentview.bottomAnchor).isActive = true
        stackview.leadingAnchor.constraint(equalTo: contentview.leadingAnchor).isActive = true
        stackview.trailingAnchor.constraint(equalTo: contentview.trailingAnchor).isActive = true
        stackview.spacing = 1
        stackview.axis = .vertical
    }
    //***************************************************************************
    //******************************object_end***********************************
    //***************************************************************************


    //***************************************************************************
    //******************************function_start*******************************
    //***************************************************************************
    
    @objc func buttonTouched(_sender: BlockButton){
        if _sender.alpha != 0{
            let alert = UIAlertController(title: "選擇解封或刪除", message: "\n解封：解除封鎖，返回好友頁面之後可找到\n\n刪除：刪除好友，雙方好友資訊將會永久刪除", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "解封", style: .destructive, handler: { _ in
                FriendLocalDefault.blockDictionary[_sender.id!] = nil
                db.collection("block").document(Profile.account).updateData([_sender.id: FieldValue.delete()])
                _sender.alpha = 0
            }))
            alert.addAction(UIAlertAction(title: "刪除", style: .destructive, handler: { _ in
                FriendLocalDefault.blockDictionary[_sender.id!] = nil
                FriendLocalDefault.blockDictionary[_sender.id!] = nil
                db.collection("block").document(Profile.account).updateData([_sender.id: FieldValue.delete()])
                db.collection("friends").document(Profile.account).updateData([_sender.id: FieldValue.delete()])
                db.collection("friends").document(_sender.id!).updateData([Profile.account: FieldValue.delete()])
                _sender.alpha = 0
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //***************************************************************************
    //******************************function_end*********************************
    //***************************************************************************

}

class BlockButton: UIButton{
    var id: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
