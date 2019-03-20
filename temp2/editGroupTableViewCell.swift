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
class editGroupContactCell: UITableViewCell {
    
        var database: Connection!
    
        var usersTable = Table("1")
        var tabname = ""
        let column = Expression<String>("number")
    
    
    @objc private func setButtonOn(num: String)-> Bool{
        var flag = 0
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent(tabname).appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
        
        do {
            let users = try self.database.prepare(self.usersTable)
            for user in users {
                //print("userNumber: \(user[self.number])")
                
                let number = user[self.column]
                //print(number)
                //print(num)
                //print("-----")
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
    
    


    var link: editGroupTableViewController?
    
    func temp(cN : String?, name: String?){
        //print("We in group temp")
        //print(cN!)
        usersTable = Table(name!)
        tabname = name!
        
        let starButton = UISwitch(frame:CGRect(x: 150, y: 150, width: 0, height: 0))
        starButton.addTarget(self, action:#selector(add_to_blocklist(_:)),for: .valueChanged)
        //print("1 new")
        starButton.setOn(false, animated: false)
        let boolean = setButtonOn(num: cN!)
                if(boolean){
                    starButton.setOn(true, animated: false)
                }
                else{
                    starButton.setOn(false, animated: false)
                }
        
        accessoryView = starButton
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
    }
    
    
    @objc private func add_to_blocklist(_ sender: UISwitch){
        if(sender.isOn ==  true){
            print("add to database")
            link?.someMethodIWantToCallInsertedit(cell: self)
        }
        else{
            print("abdbs")
            link?.someMethodIWantToCallRemoveedit(cell: self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
