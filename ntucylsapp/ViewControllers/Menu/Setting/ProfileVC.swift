//
//  PersonInfoVC.swift
//  ntucylsapp
//
//  Created by Yian Chen on 2020/9/17.
//  Copyright © 2020 Yian Chen. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class ProfileVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = colors.defaultUIColor()
        //set dismiss keyboard
        self.hideKeyboardWhenTappedAround()
        
        //set navigationBarItem
        let navigationButton = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(navigationButtonTouched(_sender:)))
        navigationItem.rightBarButtonItem = navigationButton
              
        //set scrollview
        let scrollview = scrollView()
        //set dynamic scrollview , photoview , upload button
        let oneview = oneView(scrollview: scrollview)
        let photo = photoview(oneview: oneview)
        let uploadButton = uploadPhotoBUtton(oneview: oneview, imageview: photo)
        
        // add loading spinner
        view.addSubview(loadingSpinner)
        loadingSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingSpinner.setup()
        
        //load profile image
        loadingSpinner.startSpinning()
        var profileURL: URL?
        storage.child("profile_photo/\(Profile.account).jpeg").downloadURL { (url, err) in
            if let url = url, err == nil{
                profileURL = url
            }
            if profileURL != nil{
                DispatchQueue.main.async {
                    let imageData = try? Data(contentsOf: profileURL!)
                    let image = UIImage(data: imageData!)
                    photo.image = image
                    self.loadingSpinner.stopSpinning()
                }
            }else{
                self.loadingSpinner.stopSpinning()
            }
        }
        //set account field
        let accountLabel = titleLabel(title: "帳號", oneview: oneview)
        oneview.addSubview(accountLabel)
        accountLabel.topAnchor.constraint(equalTo: uploadButton.bottomAnchor, constant: 20).isActive = true
        TextfieldSetup.defaultType(textfield: accountField, view: view, oneview: oneview, placeholder: "Account")
        accountField.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 5).isActive = true
        
        //exclude account textfield since it cannot be modified
        // another fieldArray is below the objc func
        let fieldArray = [nameField, gradeField, homeField, groupField, epochField, countField]
        
        for i in 0...fieldArray.count-1{
            //set title lable
            let titlelabel = titleLabel(title: titleArray[i], oneview: oneview)
            
            //set textfield
            fieldArray[i].text = profileArray[i]
            fieldArray[i].delegate = self
            fieldArray[i].isUserInteractionEnabled = false
            TextfieldSetup.defaultType(textfield: fieldArray[i], view: view, oneview: oneview, placeholder: ("請輸入您的"+titleArray[i]) )
            
            // set their locations
            if i==0{
                titlelabel.topAnchor.constraint(equalTo: accountField.bottomAnchor, constant: 20).isActive = true
                fieldArray[i].topAnchor.constraint(equalTo: titlelabel.bottomAnchor, constant: 5).isActive = true
            }else{
                titlelabel.topAnchor.constraint(equalTo: fieldArray[i-1].bottomAnchor, constant: 20).isActive = true
                fieldArray[i].topAnchor.constraint(equalTo: titlelabel.bottomAnchor, constant: 5).isActive = true
            }
            if i == fieldArray.count-1{
                fieldArray[i].bottomAnchor.constraint(equalTo: oneview.bottomAnchor, constant: -50).isActive = true
            }
        }
    }
    
    //***************************************************************************
    //******************************object_start*********************************
    //***************************************************************************
    
    //bool for edit
    private var editBool = false
    
    //scrollview
    func scrollView()->UIScrollView{
        let scrollview = UIScrollView()
        view.addSubview(scrollview)
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        scrollview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollview.alwaysBounceVertical = true
        return scrollview
    }
    
    func oneView(scrollview: UIScrollView)->UIView{
        let oneview = UIView()
        scrollview.addSubview(oneview)
        oneview.translatesAutoresizingMaskIntoConstraints = false
        oneview.topAnchor.constraint(equalTo: scrollview.topAnchor).isActive = true
        oneview.bottomAnchor.constraint(equalTo: scrollview.bottomAnchor).isActive = true
        oneview.leadingAnchor.constraint(equalTo: scrollview.leadingAnchor).isActive = true
        oneview.trailingAnchor.constraint(equalTo: scrollview.trailingAnchor).isActive = true
        oneview.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        let heightConstraint = oneview.heightAnchor.constraint(equalTo: view.heightAnchor)
        heightConstraint.priority = .defaultLow
        heightConstraint.isActive = true
        return oneview
    }
    
    func photoview(oneview: UIView)->UIImageView{
        let imageview = UIImageView()
        oneview.addSubview(imageview)
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageview.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        imageview.heightAnchor.constraint(equalTo: imageview.widthAnchor).isActive = true
        imageview.topAnchor.constraint(equalTo: oneview.topAnchor, constant: 30).isActive = true
        imageview.contentMode = .scaleAspectFit
        return imageview
    }
    
    func uploadPhotoBUtton(oneview: UIView, imageview: UIImageView)->UIButton{
        let button = UIButton()
        oneview.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.topAnchor.constraint(equalTo: imageview.bottomAnchor, constant: 10).isActive = true
        button.layer.borderWidth = 0.5
        button.layer.borderColor = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "DFChu-W4-WIN-BF", size: 25)
        button.layer.cornerRadius = 5
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.baselineAdjustment = .alignCenters
        button.setTitle("Upload photo", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(uploadTouched(_sender:)), for: .touchUpInside)
        return button
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
    
    //create views contains title and textfield
    private let accountField: UITextField = {
        let field = UITextField()
        field.isUserInteractionEnabled = false // disable user to modify the textfield
        field.text = Profile.account
        return field
    }()
    
    //other fields
    private var profileArray = [Profile.name, Profile.grade, Profile.home, Profile.group, Profile.epoch, Profile.count]
    private let titleArray = ["名字","系級 (簡寫)","家","部","出隊次數","第幾屆的新生"]
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
    
    //navigation button objc func
    @objc func navigationButtonTouched(_sender: UIBarButtonItem){
        let fieldArray = [nameField, gradeField, homeField, groupField, epochField, countField]
        if editBool == false{
            // change the navigation button
            _sender.title = "Done"
            _sender.tintColor = .red
            editBool = true
            // enable user to modify
            for i in 0...fieldArray.count-1 { fieldArray[i].isUserInteractionEnabled = true }
        }else{
            let alert = UIAlertController(title: "是否儲存修改？", message: "Do you want to save.", preferredStyle: .alert)
            // if they save, save it
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (UIAlertAction) in
                for i in 0...fieldArray.count-1{
                    if fieldArray[i].text != self.profileArray[i]{
                        db.collection("profile").document(Profile.account).setData([Profile.keyArray[i]:fieldArray[i].text!], merge: true)
                        self.profileArray[i] = fieldArray[i].text!
                    }
                    Profile.getProfiles()
                }
            }))
            // otherswise they don't save
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
                for i in 0...fieldArray.count-1 { fieldArray[i].text = self.profileArray[i] }
            }))
            
            // disable user to modify
            self.present(alert, animated: true, completion: nil)
            _sender.title = "Edit"
            _sender.tintColor = .systemBlue
            editBool = false
            for i in 0...fieldArray.count-1 { fieldArray[i].isUserInteractionEnabled = false }
        }
    }

    //for dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // start to let user choose photo from their photo library
    @objc func uploadTouched(_sender: UIButton){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        guard let imageDate = image.jpegData(compressionQuality: 0) else{
            return
        }
        storage.child("profile_photo/\(Profile.account).jpeg").putData(imageDate, metadata: nil) { (_, error) in
            guard error == nil else{
                print(error!)
                return
            }
            // store the photo url locally
            storage.child("profile_photo/\(Profile.account).png").downloadURL { (url, error) in
                guard let url = url, error == nil else{
                    return
                }
                let urlString = url.absoluteString
                localstore.set(urlString, forKey: "profileURL")
            }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    
    //***************************************************************************
    //******************************function_end*********************************
    //***************************************************************************
}
