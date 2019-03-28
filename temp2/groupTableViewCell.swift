//
//  groupTableViewCell.swift
//  temp2
//
//  Created by Akshat Agrawal on 19/03/19.
//  Copyright © 2019 Akshat Agrawal. All rights reserved.
//

import UIKit
import SQLite
class groupTableViewCell: UITableViewCell {
    
    var database: Connection!
    
    var groupNamesTable = Table("GroupNameTable")
    var gColumn = Expression<String>("names")
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var delBtn: UIButton!
    @IBOutlet weak var edit: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var link: showGroupsTableViewController?
    
    func temp(cN : String?){

        let starButton = UISwitch(frame:CGRect(x: 150, y: 150, width: 0, height: 0))
        //starButton.bounds
        //starButton.bounds
        starButton.addTarget(self, action:#selector(add_to_blocklist(_:)),for: .valueChanged)
        
        
//        let boolean = setButtonOn(num: cN!)
//        if(boolean){
//            starButton.setOn(true, animated: false)
//        }
//        else{
//            starButton.setOn(false, animated: false)
//        }
        //        let boolean = fetchContacts()
        //        if(boolean){
        //            starButton.setOn(true, animated: false)
        //        }
        //        else{
        //            starButton.setOn(false, animated: false)
        //        }
        //self.view.addSubview(switchDemo)
        accessoryView = starButton
    }
    
    @objc private func add_to_blocklist(_ sender: UISwitch){
        if(sender.isOn ==  true){
            print("add to database")
            //link?.someMethodIWantToCallInsert(cell: self)
        }
        else{
            //link?.someMethodIWantToCallRemove(cell: self)
        }
    }
    
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
