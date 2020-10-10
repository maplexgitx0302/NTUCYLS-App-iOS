//
//  AddFriendVC.swift
//  ntucylsapp
//
//  Created by Yian Chen on 2020/9/22.
//  Copyright © 2020 Yian Chen. All rights reserved.
//

import UIKit
import FirebaseFirestore

class AddFriendVC: UIViewController, UITextFieldDelegate {

    override func viewDidLoad(){
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.searchByIDField.delegate = self
        self.searchByNameField.delegate = self
        view.backgroundColor = colors.defaultUIColor()
        
        //search people textfield
        TextfieldSetup.defaultType(textfield: searchByNameField, view: view, placeholder: "輸入名字以查詢")
        TextfieldSetup.defaultType(textfield: searchByIDField, view: view, placeholder: "輸入學號以查詢")
        searchByNameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        searchByIDField.topAnchor.constraint(equalTo: searchByNameField.bottomAnchor, constant: 5).isActive = true
        
        //add loading spinner
        view.addSubview(loadingSpinner)
        loadingSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingSpinner.setup()
        
        //start adding stackview of invitation
        backgroundscrollviewSetup()
        scrollviewSetup()
        contentviewSetup()
        stackviewSetup()
        loadingSpinner.startSpinning()
        
        let invitations = db.collection("invitation").document(Profile.account)
        invitations.getDocument { (document, error) in
            // ****************** get invitations **************************
            if let document = document, document.exists{
                for info in document.data()!{
                    let newview = UIView()
                    self.stackview.addArrangedSubview(newview)
                    newview.translatesAutoresizingMaskIntoConstraints = false
                    newview.heightAnchor.constraint(equalToConstant: 50).isActive = true
                    newview.backgroundColor = colors.defaultLightUIColor()
                    
                    let label = UILabel()
                    newview.addSubview(label)
                    label.translatesAutoresizingMaskIntoConstraints = false
                    label.heightAnchor.constraint(equalTo: newview.heightAnchor).isActive = true
                    label.widthAnchor.constraint(equalTo: newview.widthAnchor, multiplier: 0.65).isActive = true
                    label.leadingAnchor.constraint(equalTo: newview.leadingAnchor).isActive = true
                    label.topAnchor.constraint(equalTo: newview.topAnchor).isActive = true
                    label.adjustsFontSizeToFitWidth = true
                    label.text = "  " + (info.value as! String)
                    label.font = UIFont(name: "DFChu-W4-WIN-BF", size: 20)
                    label.textColor = .white
                    label.numberOfLines = 1
                    label.baselineAdjustment = .alignCenters
                    
                    
                    let addButton = AddButton()
                    let deleteButton = DeleteButton()
                    self.addButtonDic[info.key] = addButton
                    self.deleteButtonDic[info.key] = deleteButton
                    addButton.inviterID = info.key as String
                    addButton.inviterValue = (info.value as! String)
                    deleteButton.inviterID = info.key as String
                    addButton.addTarget(self, action: #selector(self.addTouched(_sender:)), for: .touchUpInside)
                    deleteButton.addTarget(self, action: #selector(self.deleteTouched(_sender:)), for: .touchUpInside)
                    newview.addSubview(addButton)
                    newview.addSubview(deleteButton)
                    addButton.translatesAutoresizingMaskIntoConstraints = false
                    deleteButton.translatesAutoresizingMaskIntoConstraints = false
                    addButton.widthAnchor.constraint(equalTo: newview.heightAnchor).isActive = true
                    addButton.heightAnchor.constraint(equalTo: newview.heightAnchor).isActive = true
                    deleteButton.widthAnchor.constraint(equalTo: newview.heightAnchor).isActive = true
                    deleteButton.heightAnchor.constraint(equalTo: newview.heightAnchor).isActive = true
                    
                    addButton.topAnchor.constraint(equalTo: newview.topAnchor).isActive = true
                    deleteButton.topAnchor.constraint(equalTo: newview.topAnchor).isActive = true
                    addButton.leadingAnchor.constraint(equalTo: label.trailingAnchor).isActive = true
                    deleteButton.trailingAnchor.constraint(equalTo: newview.trailingAnchor).isActive = true
                    addButton.setImage(UIImage(named: "icon_check"), for: .normal)
                    deleteButton.setImage(UIImage(named: "icon_cross"), for: .normal)
                }
                self.loadingSpinner.stopSpinning()
            }
            self.loadingSpinner.stopSpinning()
            // ****************** get invitations **************************
        }
        
    }
    
    //***************************************************************************
    //******************************object_start*********************************
    //***************************************************************************
    
    //loading spin
    private let loadingSpinner = LoadingSpinner()
    
    //search field
    private let searchByNameField = UITextField()
    private let searchByIDField = UITextField()
    
    //invitation object
    private let backgroundscrollview = UIScrollView()
    func backgroundscrollviewSetup(){
        view.addSubview(backgroundscrollview)
        backgroundscrollview.translatesAutoresizingMaskIntoConstraints = false
        backgroundscrollview.topAnchor.constraint(equalTo: searchByIDField.bottomAnchor, constant: 20).isActive = true
        backgroundscrollview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundscrollview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundscrollview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundscrollview.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    private let scrollview = UIScrollView()
    func scrollviewSetup(){
        view.addSubview(scrollview)
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        scrollview.alwaysBounceVertical = true
        scrollview.topAnchor.constraint(equalTo: backgroundscrollview.topAnchor).isActive = true
        scrollview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    private let contentview = UIView()
    func contentviewSetup(){
        scrollview.addSubview(contentview)
        contentview.translatesAutoresizingMaskIntoConstraints = false
        contentview.topAnchor.constraint(equalTo: scrollview.topAnchor).isActive = true
        contentview.bottomAnchor.constraint(equalTo: scrollview.bottomAnchor).isActive = true
        contentview.leadingAnchor.constraint(equalTo: scrollview.leadingAnchor).isActive = true
        contentview.trailingAnchor.constraint(equalTo: scrollview.trailingAnchor).isActive = true
        contentview.widthAnchor.constraint(equalTo: backgroundscrollview.widthAnchor).isActive = true
        let heightConstraint = contentview.heightAnchor.constraint(equalTo: backgroundscrollview.heightAnchor)
        heightConstraint.isActive = true
        heightConstraint.priority = .defaultLow
    }
    // for invitations
    private let stackview = UIStackView()
    func stackviewSetup(){
        contentview.addSubview(stackview)
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.topAnchor.constraint(equalTo: contentview.topAnchor).isActive = true
        stackview.bottomAnchor.constraint(equalTo: contentview.bottomAnchor).isActive = true
        stackview.leadingAnchor.constraint(equalTo: contentview.leadingAnchor).isActive = true
        stackview.trailingAnchor.constraint(equalTo: contentview.trailingAnchor).isActive = true
        stackview.axis = .vertical
        stackview.spacing = 20
    }
    
    var addButtonDic: [String:AddButton] = [:]
    var deleteButtonDic: [String:DeleteButton] = [:]
    //***************************************************************************
    //******************************object_end***********************************
    //***************************************************************************


    //***************************************************************************
    //******************************function_start*******************************
    //***************************************************************************
    @objc func addTouched(_sender: AddButton){
        if _sender.alpha != 0 {
            db.collection("invitation").document(Profile.account).updateData([_sender.inviterID : FieldValue.delete()])
            db.collection("friends").document(Profile.account).setData([_sender.inviterID!: _sender.inviterID!], merge: true)
            db.collection("friends").document(_sender.inviterID!).setData([Profile.account:Profile.account], merge: true)
            _sender.alpha = 0
            self.deleteButtonDic[_sender.inviterID!]?.alpha = 0
        }
    }
    @objc func deleteTouched(_sender: DeleteButton){
        if _sender.alpha != 0{
            db.collection("invitation").document(Profile.account).updateData([_sender.inviterID : FieldValue.delete()])
            _sender.alpha = 0
            self.addButtonDic[_sender.inviterID!]?.alpha = 0
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // this will dismiss the keyboard
        if textField == searchByIDField{
            let profileID = textField.text?.lowercased()
            if profileID == Profile.account{
                Alerts.defaultAlert(title: "請不要加自己好友", message: "加自己好友會顯得很可憐唷～", UIvc: self)
            }else{
                if profileID != "" && profileID != nil{
                    let profile = db.collection("profile").document(profileID!)
                    profile.getDocument { (document, error) in
                        if let document = document, document.exists {
                            //check if they were already friends
                            let friends = db.collection("friends").document(Profile.account)
                            friends.getDocument { (check_document, error) in
                                if let check_document = check_document ,check_document.exists{
                                    // check
                                    if check_document[profileID!] != nil{
                                        Alerts.defaultAlert(title: "已經是好友囉～", message: "好朋友只是朋友", UIvc: self)
                                    }else{
                                        //send successful invite
                                        let sendInfo = Profile.account + "  " + Profile.name!
                                        let target_invitation = db.collection("invitation").document(profileID!)
                                        target_invitation.setData([Profile.account: sendInfo], merge: true)
                                        Alerts.defaultAlert(title: "已送出邀請", message:"等對方確認後，即會出現在好友列表喔！", UIvc: self)
                                    }
                                }
                            }
                        } else {
                            Alerts.defaultAlert(title: "查無此人", message: error?.localizedDescription ?? "Not Found", UIvc: self)
                        }
                    }
                }
            }
        }else if textField == searchByNameField{
            let profileName = textField.text
            if profileName == Profile.name{
                Alerts.defaultAlert(title: "請不要加自己好友", message: "加自己好友會顯得很可憐唷～", UIvc: self)
            }else{
                if profileName != "" && profileName != nil{
                    //check if they were friend already
                    //******************************************check start*****************************
                    let check_name = db.collection("profile").whereField("name", isEqualTo: profileName!)
                    check_name.getDocuments { (querySnapshot, err) in
                        let friendlist = db.collection("friends").document(Profile.account)
                        friendlist.getDocument { (friendDoc, error) in  //friendDoc is this owner's friend list
                            if let friendDoc = friendDoc, friendDoc.exists{
                                var checkIsAlreadyFriend = false
                                for document in querySnapshot!.documents{
                                    if friendDoc[document.documentID] != nil{
                                        checkIsAlreadyFriend = true
                                    }
                                }
                                //********************send start*******************
                                if checkIsAlreadyFriend == true{
                                    Alerts.defaultAlert(title: "已經是好友囉～", message: "好朋友只是朋友", UIvc: self)
                                }else if checkIsAlreadyFriend == false{
                                    let doc = db.collection("profile").whereField("name", isEqualTo: profileName!)
                                    doc.getDocuments { (querySnapshot, err) in
                                        if let err = err {
                                            Alerts.defaultAlert(title: "Error", message: err.localizedDescription, UIvc: self)
                                        } else {
                                            var existBool = false //check if this one exist
                                            let sendInfo = Profile.account + "  " + Profile.name!
                                            for document in querySnapshot!.documents {
                                                db.collection("invitation").document(document.documentID).setData([Profile.account: sendInfo], merge: true)
                                                existBool = true
                                            }
                                            if existBool{
                                                Alerts.defaultAlert(title: "已送出邀請", message:"等對方確認後，即會出現在好友列表喔！", UIvc: self)
                                            }else{
                                                Alerts.defaultAlert(title: "查無此人", message: err?.localizedDescription ?? "Not Found", UIvc: self)
                                            }
                                        }
                                    }
                                }
                                //********************send end*******************
                            }
                        }
                    }
                    //******************************************check end*******************************
                }
            }
        }
        
        
        return true
    }

    //***************************************************************************
    //******************************function_end*********************************
    //***************************************************************************
}

class AddButton: UIButton{
    var inviterID:String?
    var inviterValue:String?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
}

class DeleteButton: UIButton{
    var inviterID:String?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
}
