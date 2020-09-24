//
//  AccountInformation.swift
//  ntucylsapp
//
//  Created by Yian Chen on 2020/9/16.
//  Copyright © 2020 Yian Chen. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import UIKit

let db = Firestore.firestore()
let localstore = UserDefaults.standard
let storage = Storage.storage().reference()

struct Profile {
    static var account = localstore.object(forKey: "account") as! String
    static var name: String?
    static var grade: String?
    static var home: String?
    static var group: String?
    static var epoch: String?
    static var count: String?
    static var keyArray = ["name","grade","home","group","count","epoch"]
    
    // connect to firestore
    static func getProfiles(){
        let profilesRef = db.collection("profile").document(Profile.account)
        profilesRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let profiles = document.data()
                Profile.name = profiles?["name"] as? String ?? ""
                Profile.grade = profiles?["grade"] as? String ?? ""
                Profile.home = profiles?["home"] as? String ?? ""
                Profile.group = profiles?["group"] as? String ?? ""
                Profile.epoch = profiles?["epoch"] as? String ?? ""
                Profile.count = profiles?["count"] as? String ?? ""
            } else {
                print("Error")
            }
        }
    }
}

