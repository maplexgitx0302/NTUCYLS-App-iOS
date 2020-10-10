//
//  ColorVC.swift
//  ntucylsapp
//
//  Created by Yian Chen on 2020/9/17.
//  Copyright © 2020 Yian Chen. All rights reserved.
//

import UIKit

class ColorVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colors.defaultUIColor()
        //add scroll view
        let scrollview = scrollView()
        //set dynamic scrollview
        let oneview = oneView(scrollview: scrollview)
        //add stack view
        oneview.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: oneview.topAnchor, constant: 20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: oneview.bottomAnchor,constant: -20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: oneview.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: oneview.trailingAnchor).isActive = true
        
        // create color buttons
        let _ = colorButton(r: 41, g: 64, b: 106, lr: 82, lg: 128, lb: 212) //blue
        let _ = colorButton(r: 50, g: 50, b: 50, lr: 100, lg: 100, lb: 100) //grey
        let _ = colorButton(r: 153, g: 0, b: 0, lr: 204, lg: 0, lb: 0) //red
        let _ = colorButton(r: 167, g: 174, b: 75, lr: 203, lg: 210, lb: 96) //yellow
        let _ = colorButton(r: 0, g: 102, b: 0, lr: 0, lg: 153, lb: 0) //green
        
    }
    
    //***************************************************************************
    //******************************object_start*********************************
    //***************************************************************************
    private let stackView: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.spacing = 20
        return stackview
    }()
    
    // initialize a scrollview
    func scrollView()->UIScrollView{
        let scrollview = UIScrollView()
        view.addSubview(scrollview)
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        scrollview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollview.alwaysBounceVertical = true // can always scroll
        return scrollview
    }
    
    func oneView(scrollview: UIScrollView)->UIView{
        let oneview = UIView()
        scrollview.addSubview(oneview)
        oneview.translatesAutoresizingMaskIntoConstraints = false
        oneview.topAnchor.constraint(equalTo: scrollview.topAnchor).isActive = true
        oneview.bottomAnchor.constraint(equalTo: scrollview.bottomAnchor).isActive = true
        oneview.centerXAnchor.constraint(equalTo: scrollview.centerXAnchor).isActive = true
        oneview.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        let heightConstraint = oneview.heightAnchor.constraint(equalTo: view.heightAnchor)
        heightConstraint.priority = .defaultLow
        heightConstraint.isActive = true
        return oneview
    }
    
    func colorButton(r: CGFloat, g: CGFloat, b: CGFloat, lr: CGFloat, lg: CGFloat, lb: CGFloat)->UIView{
        
        //add to stackview
        let buttonView = UIView()
        stackView.addArrangedSubview(buttonView)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.layer.cornerRadius = 10
        buttonView.layer.borderColor = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1)
        buttonView.layer.borderWidth = 0.5
        buttonView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        buttonView.clipsToBounds = true
        
        //create left hand side dark color uiview
        let darkColorView = UIView()
        buttonView.addSubview(darkColorView)
        darkColorView.translatesAutoresizingMaskIntoConstraints = false
        darkColorView.widthAnchor.constraint(equalTo: buttonView.widthAnchor, multiplier: 0.5).isActive = true
        darkColorView.heightAnchor.constraint(equalTo: buttonView.heightAnchor).isActive = true
        darkColorView.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor).isActive = true
        darkColorView.topAnchor.constraint(equalTo: buttonView.topAnchor).isActive = true
        darkColorView.backgroundColor = colors.UIcolor(r: r, g: g, b: b, alpha: 1)
        
        
        //create right hand side light color uiview
        let lightColorView = UIView()
        buttonView.addSubview(lightColorView)
        lightColorView.translatesAutoresizingMaskIntoConstraints = false
        lightColorView.widthAnchor.constraint(equalTo: buttonView.widthAnchor, multiplier: 0.5).isActive = true
        lightColorView.heightAnchor.constraint(equalTo: buttonView.heightAnchor).isActive = true
        lightColorView.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor).isActive = true
        lightColorView.topAnchor.constraint(equalTo: buttonView.topAnchor).isActive = true
        lightColorView.backgroundColor = colors.UIcolor(r: lr, g: lg, b: lb, alpha: 1)
        
        let button = ColorButton()
        buttonView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: buttonView.topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor).isActive = true
        button.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        button.r = r; button.g=g; button.b=b; button.lr=lr; button.lg=lg; button.lb=lb
        button.addTarget(self, action: #selector(colorChoosed(_sender:)), for: .touchUpInside)
 
        return buttonView
    }
    
    //***************************************************************************
    //******************************object_end***********************************
    //***************************************************************************
    
    //***************************************************************************
    //******************************function_start*******************************
    //***************************************************************************
    @objc func colorChoosed(_sender: ColorButton){
        let alert = UIAlertController(title: "確定換此顏色？", message: "Are you sure to change the default color?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: {UIAlertAction in
            //change view to sign in view
            colors.ChangeDefaultColor(_sender: _sender, r: _sender.r!, g: _sender.g!, b: _sender.b!, lr: _sender.lr!, lg: _sender.lg!, lb: _sender.lb!)
            let directView = self.storyboard?.instantiateViewController(identifier: "MenuTBC") as? MenuTBC
            directView?.selectedIndex = 2
            self.view.window?.rootViewController = directView
            self.view.window?.makeKeyAndVisible()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    //***************************************************************************
    //******************************function_end*********************************
    //***************************************************************************
}

class ColorButton: UIButton{
    var r:CGFloat?,g:CGFloat?,b:CGFloat?,lr:CGFloat?,lg:CGFloat?,lb:CGFloat?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
}
