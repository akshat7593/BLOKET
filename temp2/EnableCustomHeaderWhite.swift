//
//  EnableCustomHeaderWhite.swift
//  temp2
//
//  Created by Akshat Agrawal on 15/04/19.
//  Copyright © 2019 Akshat Agrawal. All rights reserved.
//

import UIKit
import SQLite

class EnableCustomHeaderWhite: UITableViewCell {
    
    var link: DisplayWhiteListNumbers?
    var database: Connection!
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var white_switch: UISwitch!
    
    let enableTable = Table("enable_W_B_List")
    let action = Expression<String>("action")
    let state = Expression<Bool>("state")
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @objc func check(){
        print("check whiteList")
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("enable_W_B_List").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
        
        do {
            let users = try self.database.prepare(self.enableTable)
            for user in users {
                
                let action = user[self.action]
                let state = user[self.state]
                
                if(action=="WhiteList"){
                    white_switch.setOn(state, animated: true)
                    
                }
                
            }
            
        } catch {
            print(error)
        }
    }

    @IBAction func white_switch_action(_ sender: UISwitch) {
        if(sender.isOn ==  true){
            print("white on")
            do {
                let users = try self.database.prepare(self.enableTable)
                for user in users {
                    
                    let action = user[self.action]
                    var state = user[self.state]
                    if(action=="WhiteList"){
                        state = true
                        white_switch.setOn(true, animated: true)
                    }
                    if(action=="BlackList"){
                        state=false
                        
                    }
                    
                    let user = self.enableTable.filter(self.action == action)
                    
                    let updateUser = user.update(self.state <- state)
                    do {
                        try self.database.run(updateUser)
                        
                    } catch {
                        print(error)
                    }
                    
                }
                
            } catch {
                print(error)
            }
        }
        else{
            print("white off")
            do {
                let users = try self.database.prepare(self.enableTable)
                for user in users {
                    
                    let action = user[self.action]
                    var state = user[self.state]
                    if(action=="WhiteList"){
                        state = false
                        white_switch.setOn(false, animated: true)
                    }
                    if(action=="BlackList"){
                        state=true
                        
                    }
                    
                    let user = self.enableTable.filter(self.action == action)
                    
                    let updateUser = user.update(self.state <- state)
                    do {
                        try self.database.run(updateUser)
                        
                    } catch {
                        print(error)
                    }
                    
                }
                
            } catch {
                print(error)
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
