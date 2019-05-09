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
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //print("In BlockedContactCell")
        let deleteButton = UIButton(type: .system)
        //starButton.setImage(#imageLiteral(resourceName: "fav_star"), for: .normal)
        deleteButton.setTitle("X", for: .normal)
        deleteButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        deleteButton.tintColor = .red
        deleteButton.addTarget(self, action: #selector(add_to_blocklist(_: )), for: .touchUpInside)
        
        accessoryView = deleteButton
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @objc private func add_to_blocklist(_ sender: UISwitch){
        link?.delete(cell: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
