//
//  InfoOfFriendVC.swift
//  ntucylsapp
//
//  Created by Yian Chen on 2020/9/24.
//  Copyright © 2020 Yian Chen. All rights reserved.
//

import UIKit
import Firebase

struct TheFriendSelected{
    static var Id = ""
    static var name = ""
}

class InfoOfFriendVC: UIViewController, UIActionSheetDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colors.defaultUIColor()
        
        // report button
        let navigationButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain , target: self, action: #selector(reportButtonTouched(_sender:)))
        navigationButton.tintColor = .red
        navigationItem.rightBarButtonItem = navigationButton
        
        //set up the informations
        viewsSetup()
        
        //add loading spinner
        view.addSubview(loadingSpinner)
        loadingSpinner.setup()
        loadingSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        // get photo
        loadingSpinner.startSpinning()
        storage.child("profile_photo/\(TheFriendSelected.Id).jpeg").downloadURL { (url, err) in
            if let url = url, err == nil {
                let imageData = try? Data(contentsOf: url)
                let photoImage = UIImage(data: imageData!)
                self.photoview.image = photoImage
                self.loadingSpinner.stopSpinning()
            }else{
                self.photoview.image = UIImage(named: "cyls_icon_small")
                self.loadingSpinner.stopSpinning()
            }
        }
        
        // add fields
        let fieldArray = [nameField, gradeField, homeField, groupField, epochField, countField]
        for i in 0..<fieldArray.count{
            //set title lable
            let titlelabel = titleLabel(title: titleArray[i], oneview: contentview)
            
            //set textfield
            fieldArray[i].text = titleArray[i]
            TextfieldSetup.defaultType(textfield: fieldArray[i], view: view, oneview: contentview, placeholder: "")
            fieldArray[i].isUserInteractionEnabled = false

            if i == 0{
                titlelabel.topAnchor.constraint(equalTo: photoview.bottomAnchor, constant: 30).isActive = true
                fieldArray[i].topAnchor.constraint(equalTo: titlelabel.bottomAnchor, constant: 5).isActive = true
            }else if i == fieldArray.count-1{
                titlelabel.topAnchor.constraint(equalTo: fieldArray[i-1].bottomAnchor, constant: 20).isActive = true
                fieldArray[i].topAnchor.constraint(equalTo: titlelabel.bottomAnchor, constant: 5).isActive = true
                fieldArray[i].bottomAnchor.constraint(equalTo: contentview.bottomAnchor, constant: -50).isActive = true
            }else{
                titlelabel.topAnchor.constraint(equalTo: fieldArray[i-1].bottomAnchor, constant: 20).isActive = true
                fieldArray[i].topAnchor.constraint(equalTo: titlelabel.bottomAnchor, constant: 5).isActive = true
            }
        }
        
        // get informations
        let friendInfo = db.collection("profile").document(TheFriendSelected.Id)
        friendInfo.getDocument { (document, err) in
            if let document = document, document.exists{
                let data = document.data()
                for i in 0..<Profile.keyArray.count{
                    fieldArray[i].text = (data![Profile.keyArray[i]] as! String)
                }
            }
        }
        
    }
    
    //***************************************************************************
    //******************************object_start*********************************
    //***************************************************************************
    
    private let scrollview = UIScrollView()
    private let contentview = UIView()
    private let photoview = UIImageView()
    private let blockbutton = UIButton()
    
    //scrollview
    func viewsSetup(){
        view.addSubview(scrollview)
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        scrollview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
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
        heightConstraint.priority = .defaultLow
        heightConstraint.isActive = true
        
        contentview.addSubview(photoview)
        photoview.translatesAutoresizingMaskIntoConstraints = false
        photoview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        photoview.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        photoview.heightAnchor.constraint(equalTo: photoview.widthAnchor).isActive = true
        photoview.topAnchor.constraint(equalTo: contentview.topAnchor, constant: 30).isActive = true
        photoview.contentMode = .scaleAspectFit
        
        contentview.addSubview(blockbutton)
        blockbutton.translatesAutoresizingMaskIntoConstraints = false
        blockbutton.centerXAnchor.constraint(equalTo: photoview.centerXAnchor).isActive = true
        blockbutton.widthAnchor.constraint(equalTo: photoview.widthAnchor).isActive = true
        blockbutton.heightAnchor.constraint(equalTo: photoview.heightAnchor).isActive = true
        blockbutton.centerYAnchor.constraint(equalTo: photoview.centerYAnchor).isActive = true
        blockbutton.setImage(UIImage(named: "cyls_icon_block"), for: .normal)
        blockbutton.imageView?.contentMode = .scaleToFill
        if FriendLocalDefault.barrier == false{ blockbutton.alpha = 0 }
        else { photoview.alpha = 0 }
        blockbutton.addTarget(self, action: #selector(blockButtonTouched(_sender:)), for: .touchUpInside)
        
    }
    
    func titleLabel(title: String, oneview: UIView)->UILabel{
        let label = UILabel()
        oneview.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.font = UIFont(name: "DFChu-W4-WIN-BF", size: 20)
        label.text = title
        label.textColor = .white
        return label
    }
    
    //other fields
    private let titleArray = ["名字","系級","家","部","出隊次數","第幾屆的新生"]
    private let nameField = UITextField()
    private let gradeField = UITextField()
    private let homeField = UITextField()
    private let groupField = UITextField()
    private let epochField = UITextField()
    private let countField = UITextField()
    
    //loadind spin
    private let loadingSpinner = LoadingSpinner()
    
    //***************************************************************************
    //******************************object_end***********************************
    //***************************************************************************
    
    //***************************************************************************
    //******************************function_start*******************************
    //***************************************************************************
    
    @objc func blockButtonTouched(_sender: UIButton){
        if blockbutton.alpha != 0{
            let alert = UIAlertController(title: "確定觀看照片？", message: "照片內容可能涉及性暗示、暴力等不當內容，點選確定以觀看，或是在好友頁面關閉自動照片屏蔽。\n若有出現不當內容請檢舉告知，我們將在24小時內盡快處理。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確定", style: .destructive, handler: {_ in
                self.blockbutton.alpha = 0
                self.photoview.alpha = 1
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func reportButtonTouched(_sender: UIBarButtonItem){
        let actionSheet = UIAlertController(title: "Choose...", message: nil, preferredStyle: .actionSheet)
        //report
        let reportAction = UIAlertAction(title: "檢舉", style: .destructive, handler: {
            _ in
            let reportAlert = UIAlertController(title: "封鎖", message: nil, preferredStyle: .alert)
            reportAlert.addTextField{ (textField) in
                textField.placeholder = "請簡述原因"
            }
            reportAlert.addAction(UIAlertAction(title: "送出", style: .default, handler: {
                _ in
                db.collection("report").document(TheFriendSelected.Id).setData([Date().description : reportAlert.textFields![0].text!],merge: true)
            }))
            reportAlert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            self.present(reportAlert, animated: true, completion: nil)
        })
        //block
        let blockAction = UIAlertAction(title: "封鎖", style: .destructive) { _ in
            db.collection("block").document(Profile.account).setData([TheFriendSelected.Id:TheFriendSelected.name],merge: true)
            FriendLocalDefault.blockDictionary[TheFriendSelected.Id] = TheFriendSelected.name
            let directView = self.storyboard?.instantiateViewController(identifier: "MenuTBC") as? MenuTBC
            directView?.selectedIndex = 1
            self.view.window?.rootViewController = directView
            self.view.window?.makeKeyAndVisible()
        }
        // delete
        let deleteAction = UIAlertAction(title: "刪除", style: .default, handler: {
            _ in
            let deleteAlert = UIAlertController(title: "確定要刪除嗎？", message: "刪除後，雙方的朋友資料將同時刪除彼此。", preferredStyle: .alert)
            deleteAlert.addAction(UIAlertAction(title: "確定", style: .default, handler: {
                _ in
                db.collection("friends").document(TheFriendSelected.Id).updateData([Profile.account: FieldValue.delete()])
                db.collection("friends").document(Profile.account).updateData([TheFriendSelected.Id: FieldValue.delete()])
                let directView = self.storyboard?.instantiateViewController(identifier: "MenuTBC") as? MenuTBC
                directView?.selectedIndex = 1
                self.view.window?.rootViewController = directView
                self.view.window?.makeKeyAndVisible()
            }))
            deleteAlert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            self.present(deleteAlert, animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                
        actionSheet.addAction(reportAction)
        actionSheet.addAction(blockAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //***************************************************************************
    //******************************function_end*********************************
    //***************************************************************************
}
