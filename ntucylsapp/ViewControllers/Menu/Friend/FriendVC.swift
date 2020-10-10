//
//  FriendVC.swift
//  ntucylsapp
//
//  Created by Yian Chen on 2020/9/17.
//  Copyright © 2020 Yian Chen. All rights reserved.
//

import UIKit

struct FriendLocalDefault{
    static var barrier: Bool = localstore.object(forKey: "barrier") as? Bool ?? true
    static var blockDictionary: [String: Any] = [:]
}

class FriendVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colors.defaultLightUIColor()
        
        //set navigationBarItem
        let navigationButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.circle"), style: .done, target: self, action: #selector(plusButtonTouched(_sender:)))
        navigationButton.tintColor = .white
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
        let friendSetting = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        // add friend
        friendSetting.addAction(UIAlertAction(title: "加好友、好友邀請", style: .default, handler: { _ in
            self.performSegue(withIdentifier: "searchSegue", sender: self)
        }))
        //******************start photo barrier*******************
        friendSetting.addAction(UIAlertAction(title: "開啟/關閉 預設照片屏蔽", style: .default, handler: {
            _ in
            let open_close = UIAlertController(title: "開啟/關閉 預設照片屏蔽", message: "開啟後，每次進入好友內容頁將會自動屏蔽照片。\n若欲觀看請點擊照片一下即可。\n\n關閉後，將不會動自動屏蔽照片。", preferredStyle: .alert)
            open_close.addAction(UIAlertAction(title: "開啟", style: .default, handler: {
                _ in
                FriendLocalDefault.barrier = true
                localstore.set(true, forKey: "barrier")
            }))
            open_close.addAction(UIAlertAction(title: "關閉", style: .cancel, handler: {
                _ in
                FriendLocalDefault.barrier = false
                localstore.set(false, forKey: "barrier")
            }))
            self.present(open_close, animated: true, completion: nil)
        }))
        friendSetting.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        //******************end photo barrier*******************
        // block list
        friendSetting.addAction(UIAlertAction(title: "封鎖名單", style: .default, handler: { _ in
            self.performSegue(withIdentifier: "blockPage", sender: FriendVC.self)
        }))
        self.present(friendSetting, animated: true, completion: nil)
    }
    
    @objc func friendTouched(_sender: FriendButton){
        TheFriendSelected.Id = _sender.friendID!
        TheFriendSelected.name = _sender.name!
        performSegue(withIdentifier: "InfoOfFriend", sender: self)
    }
    
    func photoAndNameSetup(photoimageview: UIImageView, nameButton: FriendButton, friendcell: UIView){
        friendcell.translatesAutoresizingMaskIntoConstraints = false
        friendcell.backgroundColor = colors.defaultUIColor()
        friendcell.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        //photo imageview
        friendcell.addSubview(photoimageview)
        photoimageview.translatesAutoresizingMaskIntoConstraints = false
        photoimageview.heightAnchor.constraint(equalTo: friendcell.heightAnchor, constant: -10).isActive = true
        photoimageview.widthAnchor.constraint(equalTo: photoimageview.heightAnchor).isActive = true
        photoimageview.topAnchor.constraint(equalTo: friendcell.topAnchor, constant: 5).isActive = true
        photoimageview.leadingAnchor.constraint(equalTo: friendcell.leadingAnchor,constant: 5).isActive = true
        photoimageview.layer.cornerRadius = (75-10)/2
        photoimageview.clipsToBounds = true
        photoimageview.contentMode = .scaleAspectFill
        
        
        //add padding view
        let paddingview = UIView()
        friendcell.addSubview(paddingview)
        paddingview.translatesAutoresizingMaskIntoConstraints = false
        paddingview.heightAnchor.constraint(equalTo: friendcell.heightAnchor).isActive = true
        paddingview.widthAnchor.constraint(equalToConstant: 10).isActive = true
        paddingview.topAnchor.constraint(equalTo: friendcell.topAnchor).isActive = true
        paddingview.leadingAnchor.constraint(equalTo: photoimageview.trailingAnchor).isActive = true
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
                for key in keyList!{
                    if FriendLocalDefault.blockDictionary[key] == nil{
                        let friendcell = UIView()
                        let photoimageview = UIImageView()
                        let namebutton = FriendButton()
                        namebutton.friendID = key
                        namebutton.name = (data![key] as! String)
                        self.stackview.addArrangedSubview(friendcell)
                        self.photoAndNameSetup(photoimageview: photoimageview, nameButton: namebutton, friendcell: friendcell)
                        //get friend info
                        db.collection("profile").document(key).getDocument { (friendinfo, err) in
                            if let friendinfo = friendinfo, friendinfo.exists{
                                let friendname = friendinfo.data()!["name"] as! String
                                let friendgrade = friendinfo.data()!["grade"] as! String
                                namebutton.setTitle(friendname+"  "+friendgrade, for: .normal)
                            }
                        }
                        //****************************start photo****************************
                        // check photo barrier
                        // set image of photoimageview
                        if FriendLocalDefault.barrier == false{
                            storage.child("profile_photo/\(key).jpeg").downloadURL { (url, error) in
                                if let url = url, error == nil{
                                    let imageData = try? Data(contentsOf: url)
                                    let photoImage = UIImage(data: imageData!)
                                    photoimageview.image = photoImage
                                }else{
                                    photoimageview.image = UIImage(named: "cyls_icon_small")
                                }
                            }
                        }else{
                            photoimageview.image = UIImage(named: "cyls_icon_small")
                        }
                        //****************************end photo****************************
                    }
                }
                //end of for loop
            }
            self.loadingSpinner.stopSpinning()
        }
    }
    
    //***************************************************************************
    //******************************function_end*********************************
    //***************************************************************************

}

class FriendButton: UIButton{
    var friendID: String?
    var name: String?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
