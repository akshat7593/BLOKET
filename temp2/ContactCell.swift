//
//  ContactCell.swift
//  ContactsLBTA
//
//  Created by Brian Voong on 11/20/17.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
import Contacts
import SQLite
class ContactCell: UITableViewCell {
    
    var database: Connection!
    
    let usersTable = Table("blocknumbers")
    let number = Expression<String>("number")

    @objc public func setButtonOn(num: String)-> Bool{
        var flag = 0
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("blocknumbers").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
        
        do {
            let users = try self.database.prepare(self.usersTable)
            for user in users {
                //print("userNumber: \(user[self.number])")
                
                let number = user[self.number]
                print(number)
                print(num)
                print("-----")
                if(number == num){
                    flag = 1
                }
            }
            //print(blacklistData)
            
        } catch {
            print(error)
        }
        
        if(flag==1){
            return true
        }
        return false
    }
    
    var link: contactsTableViewController?
    
    func temp(cN : String?){
        print("We in temp")
        print(cN!)
        
        let starButton = UISwitch(frame:CGRect(x: 150, y: 150, width: 0, height: 0))
        starButton.addTarget(self, action:#selector(add_to_blocklist(_:)),for: .valueChanged)
        print("1 new")
        
        let boolean = setButtonOn(num: cN!)
        if(boolean){
            starButton.setOn(true, animated: false)
        }
        else{
            starButton.setOn(false, animated: false)
        }
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        

//        let starButton = UISwitch(frame:CGRect(x: 150, y: 150, width: 0, height: 0))
//        starButton.addTarget(self, action:#selector(add_to_blocklist(_:)),for: .valueChanged)
//        print("1 new")
//
//        starButton.setOn(false, animated: false)
////        let boolean = fetchContacts()
////        if(boolean){
////            starButton.setOn(true, animated: false)
////        }
////        else{
////            starButton.setOn(false, animated: false)
////        }
//        //self.view.addSubview(switchDemo)
//        accessoryView = starButton
        
        

    }
    
//    @objc private func handleMarkAsFavorite() {
//        //        print("Marking as favorite")
//        link?.someMethodIWantToCall(cell: self)
//    }
    @objc private func add_to_blocklist(_ sender: UISwitch){
        if(sender.isOn ==  true){
            print("add to database")
            link?.someMethodIWantToCallInsert(cell: self)
        }
        else{
            link?.someMethodIWantToCallRemove(cell: self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
