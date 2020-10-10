//
//  ContactVC.swift
//  ntucylsapp
//
//  Created by Yian Chen on 2020/10/1.
//  Copyright © 2020 Yian Chen. All rights reserved.
//

import UIKit

class MapVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colors.defaultUIColor()
        
        viewsSetup()
        mapAndTextSetup()
    }
    //***************************************************************************
    //******************************object_start*********************************
    //***************************************************************************
    
    private let scrollview = UIScrollView()
    private let contentview = UIView()
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
    }
    
    private let map1 = UIImageView()
    private let text1 = UITextView()
    private let map2 = UIImageView()
    private let text2 = UITextView()
    private let map3 = UIImageView()
    private let text3 = UITextView()
    func mapAndTextSetup(){
        mapAndTextInit(map: map1, text: text1)
        mapAndTextInit(map: map2, text: text2)
        mapAndTextInit(map: map3, text: text3)
        
        map1.topAnchor.constraint(equalTo: contentview.topAnchor, constant: 20).isActive = true
        text1.topAnchor.constraint(equalTo: map1.bottomAnchor, constant: 20).isActive = true
        map2.topAnchor.constraint(equalTo: text1.bottomAnchor, constant: 20).isActive = true
        text2.topAnchor.constraint(equalTo: map2.bottomAnchor, constant: 20).isActive = true
        map3.topAnchor.constraint(equalTo: text2.bottomAnchor, constant: 20).isActive = true
        text3.topAnchor.constraint(equalTo: map3.bottomAnchor, constant: 20).isActive = true
        text3.bottomAnchor.constraint(equalTo: contentview.bottomAnchor, constant: -50).isActive = true
        
        map1.image = UIImage(named: "map1")
        map2.image = UIImage(named: "map2")
        map3.image = UIImage(named: "map3")
        
        text1.text = """
        瑞峰一樓平面圖：
        ＊紅色禁止區域通常不和學校借用
        ＊大部分活動通常在穿堂，穿堂有六根柱子
        ＊菜圃通常拿來倒廚餘
        ＊三條魚廣場為戶外場地
        ＊風雨操場有桌球桌
        ＊室內活動範圍通常最遠會包含風雨操場、穿堂、校門口附近
        ＊黃色區域為洗澡間，一樓有遠左、遠右、一殘
        ＊藍色區域男廁，粉色區域女廁
        ＊廚房用具基本上應有盡有，還有冰箱
        """
        text2.text = """
        瑞峰二樓平面圖：
        ＊營本部為社團開會地點，通常禁止學員進入
        ＊小哥姐區域通常為小哥姐集散地
        ＊生態教室通常拿來睡覺，是木地板大通鋪
        ＊音樂教室有囤放一些樂器
        ＊行李間通常堆行李跟各部雜物
        ＊二樓唯一洗澡間為黃色區域，稱作二殘
        ＊曬衣場可曬衣服，通常會提供曬衣架和曬衣繩，也有洗衣板跟洗衣皂
        ＊校長室校長可能會開放，有沙發、零食、泡麵、咖啡
        ＊各班教室通常為各班休息、吃飯、開班級會議、一些活動的地點。
        """
        text3.text = """
        瑞峰三樓平面圖：
        ＊陽台可以看到三條魚廣場
        ＊室內是大禮堂，有時候中間會堆滿椅子，移開就變羽球場
        ＊講台高度很低，大約十、二十公分
        ＊鋼琴沒有壞，可以彈
        ＊燈控跟音響需要用到可以問人
        """
    }
    //***************************************************************************
    //******************************object_end***********************************
    //***************************************************************************

    //***************************************************************************
    //******************************function_start*******************************
    //***************************************************************************
    func mapAndTextInit(map: UIImageView, text: UITextView){
        contentview.addSubview(map)
        contentview.addSubview(text)
        
        map.translatesAutoresizingMaskIntoConstraints = false
        text.translatesAutoresizingMaskIntoConstraints = false
        map.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95).isActive = true
        text.widthAnchor.constraint(equalTo: map.widthAnchor).isActive = true
        map.heightAnchor.constraint(equalTo: map.widthAnchor, multiplier: 1080/1636).isActive = true
        text.heightAnchor.constraint(equalToConstant: 160).isActive = true
        map.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        text.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        map.contentMode = .scaleAspectFit
        text.layer.cornerRadius = 5
        text.backgroundColor = colors.defaultLightUIColor()
        text.font = UIFont(name: "DFFangSong-W6-WIN-BF", size: 20)
        text.isEditable = false
    }
    //***************************************************************************
    //******************************function_end*********************************
    //***************************************************************************
}
