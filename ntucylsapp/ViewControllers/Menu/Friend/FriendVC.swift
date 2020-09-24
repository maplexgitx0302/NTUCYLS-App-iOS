//
//  FriendVC.swift
//  ntucylsapp
//
//  Created by Yian Chen on 2020/9/17.
//  Copyright © 2020 Yian Chen. All rights reserved.
//

import UIKit

class FriendVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colors.defaultLightUIColor()
        
        //set navigationBarItem
        let navigationButton = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(plusButtonTouched(_sender:)))
        
        let plusFont = UIFont(name: "DFFangSong-W6-WIN-BF", size: 40)
        navigationButton.setTitleTextAttributes([NSAttributedString.Key.font: plusFont!], for: .normal)
        navigationItem.rightBarButtonItem = navigationButton
        
        //add loading spinner
        view.addSubview(loadingSpinner)
        loadingSpinner.setup()
        loadingSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        //add scroll to refresh
        scrollview.addSubview(refreshview)
        refreshview.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
        //setup all needed views
        viewsSetup()
        
        //start adding info
        addFriendsInfo()
        
        
    }

    //***************************************************************************
    //******************************object_start*********************************
    //***************************************************************************
    private let refreshview = UIRefreshControl()
    private let loadingSpinner = LoadingSpinner()
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
    @objc func didPullToRefresh(){
        stackview.removeFromSuperview()
        stackview = UIStackView()
        contentview.addSubview(stackview)
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.topAnchor.constraint(equalTo: contentview.topAnchor).isActive = true
        stackview.bottomAnchor.constraint(equalTo: contentview.bottomAnchor).isActive = true
        stackview.leadingAnchor.constraint(equalTo: contentview.leadingAnchor).isActive = true
        stackview.trailingAnchor.constraint(equalTo: contentview.trailingAnchor).isActive = true
        stackview.spacing = 1
        stackview.axis = .vertical
        self.addFriendsInfo()
        self.refreshview.endRefreshing()
    }
    
    @objc func plusButtonTouched(_sender : UIButton){
        performSegue(withIdentifier: "searchSegue", sender: self)
    }
    
    @objc func friendTouched(_sender: FriendButton){
        TheFriendSelected.Id = _sender.friendID!
        performSegue(withIdentifier: "InfoOfFriend", sender: self)
    }
    
    func photoAndNameSetup(photoButton: FriendButton, nameButton: FriendButton, friendcell: UIView){
        friendcell.translatesAutoresizingMaskIntoConstraints = false
        friendcell.backgroundColor = colors.defaultUIColor()
        friendcell.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        //photo imageview
        friendcell.addSubview(photoButton)
        photoButton.translatesAutoresizingMaskIntoConstraints = false
        photoButton.heightAnchor.constraint(equalTo: friendcell.heightAnchor).isActive = true
        photoButton.widthAnchor.constraint(equalTo: photoButton.heightAnchor).isActive = true
        photoButton.topAnchor.constraint(equalTo: friendcell.topAnchor).isActive = true
        photoButton.leadingAnchor.constraint(equalTo: friendcell.leadingAnchor).isActive = true
        photoButton.contentMode = .scaleAspectFill
        
        
        //add padding view
        let paddingview = UIView()
        friendcell.addSubview(paddingview)
        paddingview.translatesAutoresizingMaskIntoConstraints = false
        paddingview.heightAnchor.constraint(equalTo: friendcell.heightAnchor).isActive = true
        paddingview.widthAnchor.constraint(equalToConstant: 10).isActive = true
        paddingview.topAnchor.constraint(equalTo: friendcell.topAnchor).isActive = true
        paddingview.leadingAnchor.constraint(equalTo: photoButton.trailingAnchor).isActive = true
        paddingview.alpha = 0
        
        //name info
        friendcell.addSubview(nameButton)
        nameButton.translatesAutoresizingMaskIntoConstraints = false
        nameButton.topAnchor.constraint(equalTo: friendcell.topAnchor).isActive = true
        nameButton.trailingAnchor.constraint(equalTo: friendcell.trailingAnchor).isActive = true
        nameButton.leadingAnchor.constraint(equalTo: paddingview.trailingAnchor).isActive = true
        nameButton.heightAnchor.constraint(equalTo: friendcell.heightAnchor).isActive = true
        nameButton.backgroundColor = colors.defaultUIColor()
        nameButton.setTitleColor(.white, for: .normal)
        nameButton.titleLabel?.font = UIFont(name: "DFChu-W4-WIN-BF", size: 30)
        nameButton.titleLabel?.numberOfLines = 1
        nameButton.titleLabel?.baselineAdjustment = .alignCenters
        nameButton.contentHorizontalAlignment = .left
        nameButton.titleLabel?.adjustsFontSizeToFitWidth = true
        nameButton.addTarget(self, action: #selector(friendTouched(_sender:)), for: .touchUpInside)
    }
    
    func addFriendsInfo(){
        loadingSpinner.startSpinning()
        let friendDoc = db.collection("friends").document(Profile.account)
        friendDoc.getDocument { (document, error) in
            if let document = document, document.exists{
                let data = document.data()
                let keyList = data?.keys
                var count = 0
                let totalcount = keyList?.count
                for key in keyList!{
                    count += 1
                    let friendcell = UIView()
                    let photobutton = FriendButton()
                    let namebutton = FriendButton()
                    photobutton.friendID = key
                    namebutton.friendID = key
                    self.stackview.addArrangedSubview(friendcell)
                    self.photoAndNameSetup(photoButton: photobutton, nameButton: namebutton, friendcell: friendcell)
                    namebutton.setTitle((data![key] as! String), for: .normal)
                    
                    // set image of photobutton
                    storage.child("profile_photo/\(key).jpeg").downloadURL { (url, error) in
                        if let url = url, error == nil{
                            let imageData = try? Data(contentsOf: url)
                            let photoImage = UIImage(data: imageData!)
                            photobutton.setImage(photoImage, for: .normal)
                            if count == totalcount{self.loadingSpinner.stopSpinning()}
                        }else{
                            photobutton.setImage(UIImage(named: "cyls_icon_small"), for: .normal)
                            if count == totalcount{self.loadingSpinner.stopSpinning()}
                        }
                    }
                }
            }
        }
    }
    
    //***************************************************************************
    //******************************function_end*********************************
    //***************************************************************************

}

class FriendButton: UIButton{
    var friendID: String?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
