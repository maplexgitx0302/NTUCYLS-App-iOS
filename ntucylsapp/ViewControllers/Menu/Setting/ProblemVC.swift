//
//  ProblemVC.swift
//  ntucylsapp
//
//  Created by Yian Chen on 2020/10/1.
//  Copyright © 2020 Yian Chen. All rights reserved.
//

import UIKit

class ProblemVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = colors.defaultUIColor()
        
        quesfieldsetup()
        pickerviewstup()
        describetextviewsetup()
        sendbuttonsetup()
    }
    
    //***************************************************************************
    //******************************object_start*********************************
    //***************************************************************************
    let quesField = UITextField()
    func quesfieldsetup(){
        TextfieldSetup.defaultType(textfield: quesField, view: view, placeholder: "asdasd")
        quesField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        quesField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
        quesField.placeholder = "Select question type"
    }
    let dataPicker = UIPickerView()
    let problemList = ["APP BUG","社課、學期活動","平服、假服","社辦","其他問題"]
    func pickerviewstup(){
        quesField.inputView = dataPicker
        dataPicker.delegate = self
        dataPicker.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .systemBlue
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(donePicker(_sender:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPicker(_sender:)))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        quesField.inputAccessoryView = toolBar
    }
    
    let describeTextview = UITextView()
    func describetextviewsetup(){
        view.addSubview(describeTextview)
        describeTextview.delegate = self
        describeTextview.translatesAutoresizingMaskIntoConstraints = false
        describeTextview.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        describeTextview.topAnchor.constraint(equalTo: quesField.bottomAnchor,constant: 30).isActive = true
        describeTextview.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 0.3).isActive = true
        describeTextview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        describeTextview.layer.cornerRadius = 5
        describeTextview.layer.borderWidth = 2
        describeTextview.layer.borderColor = CGColor(srgbRed: 0.3, green: 0.3, blue: 0.3, alpha: 0.5)
        describeTextview.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        describeTextview.autocapitalizationType = .none
        describeTextview.font = UIFont.systemFont(ofSize: 18)
        describeTextview.text = "Type anything here"
        describeTextview.textColor = UIColor.lightGray
    }
    
    let sendButton = UIButton()
    func sendbuttonsetup(){
        view.addSubview(sendButton)
        ButtonSetup.loginButton(button: sendButton, view: view, text: "送出回報")
        sendButton.topAnchor.constraint(equalTo: describeTextview.bottomAnchor, constant: 30).isActive = true
        sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sendButton.addTarget(self, action: #selector(sendTouched(_sender:)), for: .touchUpInside)
    }
    
    //***************************************************************************
    //******************************object_end***********************************
    //***************************************************************************


    //***************************************************************************
    //******************************function_start*******************************
    //***************************************************************************
    
    // picker view funcs
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return problemList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return problemList[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        quesField.text = problemList[row]
    }
    @objc func donePicker(_sender: UIBarButtonItem){
        self.view.endEditing(true)
    }
    @objc func cancelPicker(_sender: UIBarButtonItem){
        self.view.endEditing(true)
    }
    // textview func
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    // send button
    @objc func sendTouched(_sender: UIButton){
        let alert = UIAlertController(title: "確認送出？", message: "請確保您的文字內容不包含人身攻擊，毀謗，造謠等不實內容", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: {
            _ in
            if self.quesField.text == "" || self.quesField.text == nil{
                Alerts.defaultAlert(title: "請選擇問題類型", message: "Choose your problem's type", UIvc: self)
            }else if self.describeTextview.text == nil || self.describeTextview.text.count < 10 || self.describeTextview.textColor != UIColor.black{
                Alerts.defaultAlert(title: "請詳述問題內容", message: "字數請勿低於10", UIvc: self)
            }else{
                // get current time
                let currenttime = Date().description
                db.collection("problem").document(self.quesField.text!).setData([currenttime : Profile.account + " : " + self.describeTextview.text!], merge: true)
                // go back to previous page
                let successalert = UIAlertController(title: "回報成功", message: "感謝您的回報，我們將盡快為您處理", preferredStyle: UIAlertController.Style.alert)
                successalert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    _ in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(successalert, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    //***************************************************************************
    //******************************function_end*********************************
    //***************************************************************************
    
}
