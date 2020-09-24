//
//  LoginViewController.swift
//  ntucylsapp
//
//  Created by Yian Chen on 2020/9/15.
//  Copyright © 2020 Yian Chen. All rights reserved.
//iuhiuhiuhiuhi
//lklkmlkmlkml

import UIKit
import FirebaseAuth

class LoginVC: UIViewController, UITextFieldDelegate {
    //add textFieldDelegate to press return dismiss keyboard
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() //to hide keyboard when touch outside
        //***************************************************************************
        //*********Start initializing everything also the locations******************
        //***************************************************************************
        //cyls icon and background color
        view.backgroundColor = colors.defaultUIColor()
        imageSetup(imageview: cylsImage) //setup cyls icon
        
        //textfield and buttons initialization
        accountField.delegate = self //to dismiss keyboard
        passwordField.delegate = self //to dismiss keyboard
        TextfieldSetup.defaultType(textfield: accountField, view: view, placeholder: "Account (ex: r08222011)")
        TextfieldSetup.defaultType(textfield: passwordField, view: view, placeholder: "Password")
        ButtonSetup.loginButton(button: registerButton, view: view, text: "Register")//apperance
        ButtonSetup.loginButton(button: loginButton, view: view, text: "Sign in")//appearance
        //other buttons spectecular functionalities are defined in their private
        
        //setup their locations
        accountField.topAnchor.constraint(equalTo: cylsImage.bottomAnchor, constant: 30).isActive = true
        passwordField.topAnchor.constraint(equalTo: accountField.bottomAnchor, constant: 20).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: passwordField.leadingAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20).isActive = true
        registerButton.trailingAnchor.constraint(equalTo: passwordField.trailingAnchor).isActive = true
        registerButton.topAnchor.constraint(equalTo: loginButton.topAnchor).isActive = true
        
        //add loading spinner
        view.addSubview(loadingSpinner)
        loadingSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingSpinner.setup()
        
        //***************************************************************************
        //*********Start to set everything about account and login*******************
        //***************************************************************************
        
    }
    
    //***************************************************************************
    //******************************object_start*********************************
    //***************************************************************************
    private let cylsImage = UIImageView()
    
    private let accountField: UITextField = {
        let field = UITextField()
        field.text = localstore.object(forKey: "local_account") as? String
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.isSecureTextEntry = true
        return field
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(directToRegisterPage), for: .touchUpInside)
        return button
    }()
    private let loginButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(signinTouched), for: .touchUpInside)
        return button
    }()
    
    private let loadingSpinner = LoadingSpinner()
    //***************************************************************************
    //******************************object_end***********************************
    //***************************************************************************
    
    
    //***************************************************************************
    //******************************functions_start******************************
    //***************************************************************************
    // direct to the page to register
    @objc func directToRegisterPage(_sender: UIButton){
        performSegue(withIdentifier: "registerPage", sender: self)
    }
    
    // for pressing return dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //setup imageview for cyls icon
    func imageSetup(imageview: UIImageView){
        view.addSubview(imageview)
        imageview.image = UIImage(named: "cyls_icon")
        imageview.contentMode = .scaleAspectFit
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageview.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        imageview.heightAnchor.constraint(equalTo: imageview.widthAnchor).isActive = true
    }
    
    //***************************************************************************
    //******************************functions_end********************************
    //***************************************************************************
    
    //***************************************************************************
    //******************************sign_in_start********************************
    //***************************************************************************
    //when sign in touched
    @objc func signinTouched(_sender: UIButton){
        var ACCOUNT = accountField.text
        let PASSWORD = passwordField.text
        var EMAIL = ""
        //********************if start*******************
        if (ACCOUNT != "" && ACCOUNT != nil) && (PASSWORD != "" && PASSWORD != nil){
            //******************************check whther is NTU student*****************
            if ACCOUNT?.contains("@") == false{
                EMAIL = ACCOUNT!.lowercased()+"@ntu.edu.tw"
                localstore.set(ACCOUNT?.lowercased(), forKey: "local_account")
            }else if ACCOUNT?.contains("@") == true{
                EMAIL = ACCOUNT!
                localstore.set(EMAIL, forKey: "local_account")
                ACCOUNT = String(ACCOUNT![...(ACCOUNT?.index(before: (ACCOUNT?.firstIndex(of: "@"))!))!])
            }
            //******************************check whther is NTU student*****************
            //******************************start sign in***************************************
            loadingSpinner.startSpinning()
            Auth.auth().signIn(withEmail: EMAIL, password: PASSWORD!) { (result, error) in
                guard error == nil else{
                    self.loadingSpinner.stopSpinning()
                    return self.handleError(error: error!)
                }
                guard let user = result?.user else{
                    self.loadingSpinner.stopSpinning()
                    fatalError("Something going wrong!!!")
                }
                
                //**************** check email verified*********************
                if user.isEmailVerified == true{
                    // save account and password
                    localstore.set(ACCOUNT, forKey: "account")
                    Profile.account = ACCOUNT!
                    Profile.getProfiles() // get other information
                    //change view to menu tab bar controller
                    let directView = self.storyboard?.instantiateViewController(identifier: "MenuTBC") as? MenuTBC
                    self.view.window?.rootViewController = directView
                    self.view.window?.makeKeyAndVisible()
                    self.loadingSpinner.stopSpinning()
                }else{
                    self.loadingSpinner.stopSpinning()
                    Alerts.defaultAlert(title: "帳號未認證", message: "Please check your email is verified.", UIvc: self)
                    user.sendEmailVerification { (Error) in
                        guard let error = Error else{
                            return
                        }
                        self.handleError(error: error)
                    }
                }
                //**************** check email verified*********************
            }
            //******************************end sign in***************************************
        }
        //********************if end*******************
    }
    
    //handle error
    func handleError(error: Error){
        Alerts.defaultAlert(title: "ERROR", message: error.localizedDescription, UIvc: self)
    }
    //***************************************************************************
    //******************************sign_in_end**********************************
    //***************************************************************************
    
}//End of class LoginVC
