//
//  showGroupsTableViewController.swift
//  temp2
//
//  Created by Akshat Agrawal on 19/03/19.
//  Copyright © 2019 Akshat Agrawal. All rights reserved.
//

import UIKit
import SQLite
class showGroupsTableViewController: UIViewController {
    var database: Connection!
    
    let usersTable = Table("GroupNameTable")
    let names = Expression<String>("names")
    
  
    @IBOutlet weak var groupTableView: UITableView!
    
    var groupDataModel:[groupNamesModal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupDataModel.removeAll()
        print("inside viewdidload")
        do {
            print("first")
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("GroupNameTable").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
        
        
        do {
            print("two")
            let users = try self.database.prepare(self.usersTable)
            for user in users {
                //print("userNumber: \(user[self.number])")
                
                let name = user[self.names]
                
                let edit = UIButton()
                edit.setTitle("Edit", for: .normal)
                
                let switchBtn = UISwitch()
                switchBtn.setOn(false, animated: true)
                groupDataModel.append(groupNamesModal(name: name,edit:edit, switchBtn:switchBtn))
            }
            //print(blacklistData)
            
        } catch {
            print(error)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
       //self.tableView.reloadData()
        //self.viewDidLoad()
    }
}

extension showGroupsTableViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        print("count of table view")
        //self.viewDidLoad()
        print(groupDataModel.count)
        return groupDataModel.count
    }
    
    
    @objc func delete_cell(sender:UIButton){
//        print("delete")
//        print(sender.accessibilityIdentifier!)
//        //print(sender.currentTitle!)
//
//        print("DELETE TAPPED")
//        guard let usernumber = sender.accessibilityIdentifier
//            //let userId = Int(userIdString)
//            else { return }
//        print(usernumber)
//
//        let user = self.usersTable.filter(self.number == usernumber)
//        let deleteUser = user.delete()
//        do {
//            try self.database.run(deleteUser)
//        } catch {
//            print(error)
//        }
//        self.tableView.reloadData()
//        self.viewDidLoad()
        
        
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        print("inside tableview function")
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupTableViewCell", for: indexPath) as! groupTableViewCell
        //var number: String
        
        
        cell.name.text = groupDataModel[indexPath.row].name
        
        cell.edit.setTitle("Edit", for: .normal)
        cell.edit.accessibilityIdentifier=cell.name.text
        //print(cell.delete.accessibilityIdentifier!)
        cell.edit.addTarget(self, action:#selector(delete_cell), for: .touchUpInside)
        
        cell.switchBtn.setOn(false, animated: true)
        
        return cell
    }
    
}

