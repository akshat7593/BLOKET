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
    
    var database1: Connection!
    
    var groupNamesTable = Table("GroupNameTable")
    var gColumn = Expression<String>("names")
    var oColumn = Expression<Bool>("onoff")
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var delBtn: UIButton!
    
    @IBOutlet weak var edit: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var link: showGroupsTableViewController?
    
    func setButtonOn(groupName: String?) -> Bool {
        var onoff = false
        do {
            //print("first")
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("GroupNameTable").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database1 = database
        } catch {
            print(error)
        }
        do {
            print("two")
            
            let users = try self.database1.prepare(self.groupNamesTable)
            for user in users {
                //print("userNumber: \(user[self.number])")
                if(user[self.gColumn].elementsEqual(groupName!)){
                    onoff = user[self.oColumn]
                }
                //groupDataModel.append(groupNamesModal(name: name,edit:edit,delBtn:del))
                
            }
            
            //print(blacklistData)
            
        } catch {
            print(error)
        }
        return onoff
    }
    
    func temp(groupName : String?){
        print(groupName)
        let starButton = UISwitch(frame:CGRect(x: 150, y: 150, width: 0, height: 0))
        //starButton.bounds
        //starButton.bounds
        starButton.addTarget(self, action:#selector(add_to_blocklist(_:)),for: .valueChanged)
        
        
        let boolean = setButtonOn(groupName : groupName!)
        if(boolean){
            starButton.setOn(true, animated: false)
        }
        else{
            starButton.setOn(false, animated: false)
        }
        
        //self.view.addSubview(starButton)
        accessoryView = starButton
    }
    
    @objc private func add_to_blocklist(_ sender: UISwitch){
        if(sender.isOn ==  true){
            print("add to database")
            //link?.someMethodIWantToCallInsert(cell: self)
        }
        else{
            print("remove to database")
            //link?.someMethodIWantToCallRemove(cell: self)
        }
    }
    
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
