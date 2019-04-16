//
//  EnableCustomHeaderGroups.swift
//  temp2
//
//  Created by Akshat Agrawal on 16/04/19.
//  Copyright © 2019 Akshat Agrawal. All rights reserved.
//

import UIKit
import SQLite

class EnableCustomHeaderGroups: UITableViewCell {
    var database: Connection!
    var link: showGroupsTableViewController?
    
    let enableTable = Table("enable_W_B_List")
    let action = Expression<String>("action")
    let state = Expression<Bool>("state")
    let b_logic = Block_logic()
    @IBOutlet weak var blacklabel: UILabel!
    @IBOutlet weak var whitelabel: UILabel!
    @IBOutlet weak var black_switch: UISwitch!
    @IBOutlet weak var white_switch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @objc func check(){
        print("check group header")
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
                
                if(action=="WhiteListGroup"){
                    white_switch.setOn(state, animated: true)
                    print(white_switch.state)
                }
                
                if(action=="BlackListGroup"){
                    black_switch.setOn(state, animated: true)
                }
                
            }
            
        } catch {
            print(error)
        }
    }

    @IBAction func black_switch_action(_ sender: UISwitch) {
        if(sender.isOn ==  true){
            do {
                let users = try self.database.prepare(self.enableTable)
                for user in users {
                    
                    let action = user[self.action]
                    var state = user[self.state]
                    if(action=="BlackListGroup"){
                        state = true
                        black_switch.setOn(true, animated: true)
                    }
                    if(action=="WhiteListGroup"){
                        state=false
                        white_switch.setOn(false, animated: true)
                    }
                    
                    let user = self.enableTable.filter(self.action == action)
                    
                    let updateUser = user.update(self.state <- state)
                    do {
                        try self.database.run(updateUser)
                        print("update on black")
                    } catch {
                        print(error)
                    }
                    
                }
                
            } catch {
                print(error)
            }
            
            //link?.groupTableView.reloadData()
            //link?.viewDidLoad()
        }
        else{
            print("white off")
            do {
                let users = try self.database.prepare(self.enableTable)
                for user in users {
                    
                    let action = user[self.action]
                    var state = user[self.state]
                    if(action=="BlackListGroup"){
                        state = false
                        black_switch.setOn(false, animated: true)
                        
                        let user = self.enableTable.filter(self.action == action)
                        
                        let updateUser = user.update(self.state <- state)
                        do {
                            try self.database.run(updateUser)
                            print("update off black")
                        } catch {
                            print(error)
                        }
                    }
                    
                }
                
            } catch {
                print(error)
            }
            
            //link?.groupTableView.reloadData()
            //link?.viewDidLoad()
        }
        link?.handleExpandClose()
        b_logic.grp_block()
    }
    
    
    
    
    
    @IBAction func white_switch_action(_ sender: UISwitch) {
        if(sender.isOn ==  true){
            do {
                let users = try self.database.prepare(self.enableTable)
                for user in users {
                    
                    let action = user[self.action]
                    var state = user[self.state]
                    if(action=="WhiteListGroup"){
                        print("inside white list")
                        state = true
                        white_switch.setOn(true, animated: true)
                    }
                    if(action=="BlackListGroup"){
                        state=false
                        black_switch.setOn(false, animated: true)
                        
                    }
                    
                    let user = self.enableTable.filter(self.action == action)
                    
                    let updateUser = user.update(self.state <- state)
                    do {
                        try self.database.run(updateUser)
                        print("update on white")
                    } catch {
                        print(error)
                    }
                    
                }
                
            } catch {
                print(error)
            }
            
            //link?.groupTableView.reloadData()
            //link?.viewDidLoad()
        }
        else{
            print("white off")
            do {
                let users = try self.database.prepare(self.enableTable)
                for user in users {
                    
                    let action = user[self.action]
                    var state = user[self.state]
                    if(action=="WhiteListGroup"){
                        state = false
                        white_switch.setOn(false, animated: true)
                        
                        let user = self.enableTable.filter(self.action == action)
                        
                        let updateUser = user.update(self.state <- state)
                        do {
                            try self.database.run(updateUser)
                            print("update off white")
                        } catch {
                            print(error)
                        }
                    }
                    
                }
                
            } catch {
                print(error)
            }
            
            //link?.groupTableView.reloadData()
            //link?.viewDidLoad()
        }
        link?.handleExpandClose()
        b_logic.grp_block()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
