//
//  EnableCustomHeaderBlack.swift
//  temp2
//
//  Created by Akshat Agrawal on 15/04/19.
//  Copyright © 2019 Akshat Agrawal. All rights reserved.
//

import UIKit
import SQLite

class EnableCustomHeaderBlack: UITableViewCell {
    var database: Connection!
    var link: DisplayBlockedNumbers?
    
    let enableTable = Table("enable_W_B_List")
    let action = Expression<String>("action")
    let state = Expression<Bool>("state")
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var black_switch: UISwitch!
    
    
    var block_logic = Block_logic()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @objc func check(){
        print("check black")
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
                
                if(action=="BlackList"){
                    black_switch.setOn(state, animated: true)
                    
                }
                
            }
            
        } catch {
            print(error)
        }
    }

    @IBAction func black_switch_action(_ sender: UISwitch) {
        if(sender.isOn ==  true){
            print("black on")
            do {
                let users = try self.database.prepare(self.enableTable)
                for user in users {
                    
                    let action = user[self.action]
                    var state = user[self.state]
                    if(action=="WhiteList"){
                        state = false
                    }
                    if(action=="BlackList"){
                        state=true
                        black_switch.setOn(true, animated: true)
                        
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
            print("black off")
            do {
                let users = try self.database.prepare(self.enableTable)
                for user in users {
                    
                    let action = user[self.action]
                    var state = user[self.state]
//                    if(action=="WhiteList"){
//                        state = true
//                    }
                    if(action=="BlackList"){
                        state=false
                        black_switch.setOn(false, animated: true)
                        let user = self.enableTable.filter(self.action == action)
                        
                        let updateUser = user.update(self.state <- state)
                        do {
                            try self.database.run(updateUser)
                            
                        } catch {
                            print(error)
                        }

                        
                    }
                    
//                    let user = self.enableTable.filter(self.action == action)
//
//                    let updateUser = user.update(self.state <- state)
//                    do {
//                        try self.database.run(updateUser)
//
//                    } catch {
//                        print(error)
//                    }
                    
                }
                
            } catch {
                print(error)
            }
        }
        //calling function in block logic file
        block_logic.black_white()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
