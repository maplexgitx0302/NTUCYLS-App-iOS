//
//  RegisterVC.swift
//  ntucylsapp
//
//  Created by Yian Chen on 2020/9/15.
//  Copyright © 2020 Yian Chen. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterVC: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = colors.defaultUIColor()

        //***************************************************************************
        //*********Start initializing everything also the locations******************
        //***************************************************************************
        // set up all locations
        accountTextfield.delegate = self // set press return dismiss keyboard
        passwordTextfield.delegate = self
        TextfieldSetup.defaultType(textfield: accountTextfield, view: view, placeholder: "Please enter your ID. ex: r08222011")
        TextfieldSetup.defaultType(textfield: passwordTextfield, view: view, placeholder: "Please enter your password.")
        passwordTextfield.isSecureTextEntry = true
        accountTextfield.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        passwordTextfield.topAnchor.constraint(equalTo: accountTextfield.bottomAnchor, constant: 15).isActive = true
        textViewSetup(textview: warningTextView)
        warningTextView.topAnchor.constraint(equalTo: passwordTextfield.bottomAnchor, constant: 15).isActive = true
        
        //set check box
        view.addSubview(checkBox); view.addSubview(checkLabel);
        checkBox.topAnchor.constraint(equalTo: warningTextView.bottomAnchor, constant: 15).isActive = true
        checkBox.leadingAnchor.constraint(equalTo: warningTextView.leadingAnchor).isActive = true
        checkLabel.centerYAnchor.constraint(equalTo: checkBox.centerYAnchor).isActive = true
        checkLabel.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: 5).isActive = true
        checkLabel.trailingAnchor.constraint(equalTo: warningTextView.trailingAnchor).isActive = true
        
        //setup send button
        ButtonSetup.loginButton(button: sendButton, view: view, text: "Send")
        sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sendButton.topAnchor.constraint(equalTo: checkBox.bottomAnchor, constant: 20).isActive = true
        //***************************************************************************
        //*********End of initializing everything also the locations*****************
        //***************************************************************************
        
        
    }
    
    //***************************************************************************
    //******************************object_start*********************************
    //***************************************************************************
    private let accountTextfield = UITextField()
    private let passwordTextfield = UITextField()
    private let warningTextView = UITextView()
    private let sendButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(sendTouch), for: .touchUpInside)
        return button
    }()
    private let checkBox: UIButton = {
        let check = UIButton()
        check.translatesAutoresizingMaskIntoConstraints = false
        check.widthAnchor.constraint(equalToConstant: 30).isActive = true
        check.heightAnchor.constraint(equalToConstant: 30).isActive = true
        check.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        check.addTarget(self, action: #selector(checkBoxIsTouched), for: .touchUpInside)
        return check
    }()
    private let checkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "我已詳閱說明 , I've read it."
        label.font = UIFont(name: "DFFangSong-W6-WIN-BF", size: 15)
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    //***************************************************************************
    //******************************object_end***********************************
    //***************************************************************************
    
    
    //***************************************************************************
    //******************************functions_start******************************
    //***************************************************************************
    
    //when send button is test
    @objc func sendTouch(_sender: UIButton){
        if accountTextfield.text != "" && passwordTextfield.text != ""{
            if accountTextfield.text!.count != 9{
                //not a NTU student
                Alerts.defaultAlert(title: "似乎不是台大學號喔～", message: "Seems like you are NOT a NTU student.", UIvc: self)
            }else if check.checkPassword(password: passwordTextfield.text!) == false{
                //contain special character
                Alerts.defaultAlert(title: "勿含特殊字元", message: "Password should NOT contain special characters.", UIvc: self)
            }else if check.checkLength(password: passwordTextfield.text!) == false{
                //not correct password length
                Alerts.defaultAlert(title: "密碼長度錯誤", message: "Password should be in range 8 ~ 20.", UIvc: self)
            }else if check.checkbool == false{
                //check box is unchecked
                Alerts.defaultAlert(title: "請詳閱說明", message: "Please read the instruction.", UIvc: self)
            }else{
                //prepare sending send email
                let email = accountTextfield.text!.lowercased() + "@ntu.edu.tw"
                let password = passwordTextfield.text!
                //create user and send email
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    guard error == nil else{
                        return self.handleError(error: error!)
                    }
                    guard let user = result?.user else{
                        fatalError("Something going wrong!!!")
                    }
                    //send email
                    user.sendEmailVerification { (Error) in
                        guard let error = Error else{
                            return
                        }
                        self.handleError(error: error)
                    }
                    //add account to firebase
                    db.collection("profile").document(self.accountTextfield.text!.lowercased()).setData(["create":""], merge: true)
                    db.collection("friends").document(self.accountTextfield.text!.lowercased()).setData(["create":""], merge: true)
                    db.collection("invitation").document(self.accountTextfield.text!.lowercased()).setData(["create":""], merge: true)
                    //delete the create dummy field
                    db.collection("profile").document(self.accountTextfield.text!.lowercased()).updateData(["create": FieldValue.delete() ])
                    db.collection("friends").document(self.accountTextfield.text!.lowercased()).updateData(["create": FieldValue.delete() ])
                    db.collection("invitation").document(self.accountTextfield.text!.lowercased()).updateData(["create": FieldValue.delete() ])
                    
                    //notify success
                    let alert = UIAlertController(title: "認證信件已送出", message: "Verification mail has been sent. Please check your NTU mail.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        UIAlertAction in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    //error handle
    func handleError(error: Error){
        Alerts.defaultAlert(title: "ERROR", message: error.localizedDescription, UIvc: self)
    }
    
    //when checkbox is touched
    @objc func checkBoxIsTouched(_sender: UIButton){
        check.checkbool = !check.checkbool
        if check.checkbool{
            _sender.setImage(UIImage(systemName: "checkmark"), for: .normal)
        }else{
            _sender.setImage(.none, for: .normal)
        }
    }
    
    // for pressing return dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func textViewSetup(textview: UITextView){
        view.addSubview(textview)
        textview.isEditable = false
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textview.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        textview.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35).isActive = true
        textview.backgroundColor = colors.defaultLightUIColor()
        textview.textColor = .white
        textview.layer.cornerRadius = 5
        textview.font = UIFont(name: "DFFangSong-W6-WIN-BF", size: 20)
        textview.text =
        """
        請詳閱使用說明：\n
        Please read the instruction (English below)\n
        注意事項：\n
        一、 請使用台大學號(大、小寫皆可)，系統會依照學號寄信\n
        二、 請在學校信箱收取確認信，點擊確認信件後方能登入使用\n
        三、 相關問題請來信，不定期回信\n
        b04502131@gmail.com
        \n
        Warning :\n
        1. Please use your NTU student ID\n
        2. Check your NTU mail, you are able to sign in after your mail is verified.\n
        3. Any question is welcome, please send it to\n
        b04502131@gmail.com
        """
    }
    //***************************************************************************
    //******************************functions_end********************************
    //***************************************************************************
}

// the check bool of check box
struct check {
    // the bool for the checkbox is checked
    static var checkbool = false
    // check whether password contain special characters
    static func checkPassword(password: String)->Bool{
        let specialChar = "`~!@#$%^&*()-_=+{}[]|\\:;'<>,.?/"
        let passwordArray = Array(password)
        for i in 0...passwordArray.count-1{
            if specialChar.contains(passwordArray[i]){
                return false
            }
        }
        return true // valid password
    }
    // check the length of the password
    static func checkLength(password: String)->Bool{
        if password.count < 8 || password.count > 20{
            return false
        }
        return true // valid password
    }
}
