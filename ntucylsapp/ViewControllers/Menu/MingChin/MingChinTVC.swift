//
//  MingChinTVC.swift
//  ntucylsapp
//
//  Created by Yian Chen on 2020/10/2.
//  Copyright © 2020 Yian Chen. All rights reserved.
//

import UIKit

class MingChinTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MingChinInfo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.backgroundColor = colors.defaultUIColor()
        let cell = tableView.dequeueReusableCell(withIdentifier: "MingChinIdentifier", for: indexPath) as! MingChinTVcell
        cell.mingChinTitleLabel.text = "鄉服第\(52+indexPath.row)屆茗情"
        cell.backgroundColor = colors.defaultLightUIColor()
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MingChinInfo.epochIndex = indexPath.row + 52
        
        performSegue(withIdentifier: "mingchinpdf", sender: self)
    }
    

}

class MingChinTVcell: UITableViewCell{
    
    @IBOutlet weak var mingChinTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

struct MingChinInfo{
    static var count = 6
    static var epochIndex = 0
}
