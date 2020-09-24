//
//  InfoOfFriendVC.swift
//  ntucylsapp
//
//  Created by Yian Chen on 2020/9/24.
//  Copyright © 2020 Yian Chen. All rights reserved.
//

import UIKit

struct TheFriendSelected{
    static var Id = ""
}

class InfoOfFriendVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colors.defaultUIColor()
        
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
}
