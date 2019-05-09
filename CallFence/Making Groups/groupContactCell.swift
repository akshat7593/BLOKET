//
//  ContactCell.swift
//  ContactsLBTA
//
//  Created by Brian Voong on 11/20/17.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
import Contacts
//import SQLite
class groupContactCell: UITableViewCell {
    
//    var database: Connection!
//
//    let usersTable = Table("blocknumbers")
//    let number = Expression<String>("number")
    
    
//    @objc private func setButtonOn(){
//        do {
//            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//            let fileUrl = documentDirectory.appendingPathComponent("blocknumbers").appendingPathExtension("sqlite3")
//            let database = try Connection(fileUrl.path)
//            self.database = database
//        } catch {
//            print(error)
//        }
//
//
//    }
    
    var link: groupContactsTableViewController?
    
    func temp(cN : String?){
        //print("We in group temp")
        //print(cN!)
        
        let starButton = UISwitch(frame:CGRect(x: 150, y: 150, width: 0, height: 0))
        starButton.addTarget(self, action:#selector(add_to_blocklist(_:)),for: .valueChanged)
        //print("1 new")
        starButton.setOn(false, animated: false)
        //let boolean = setButtonOn(num: cN!)
//        if(boolean){
//            starButton.setOn(true, animated: false)
//        }
//        else{
//            starButton.setOn(false, animated: false)
//        }

        accessoryView = starButton
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
 
    }
    

    @objc private func add_to_blocklist(_ sender: UISwitch){
        if(sender.isOn ==  true){
            print("add to database")
            link?.InsertIntoGroup(cell: self)
        }
        else{
            link?.someMethodIWantToCallRemove(cell: self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
