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
    var database1: Connection!
    var database2: Connection!
    let usersTable = Table("GroupNameTable")
    let names = Expression<String>("names")
    let cellId1 = "cellId123125"
    var groupTable = Table("1")
    var groupName = Expression<String>("number")
  
    @IBOutlet weak var groupTableView: UITableView!
    
    var groupDataModel:[groupNamesModal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupDataModel.removeAll()
        //groupTableView.register(groupTableViewCell.self, forCellReuseIdentifier: cellId1)
        print("inside viewdidload")
        do {
            print("first")
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("GroupNameTable").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database1 = database
        } catch {
            print(error)
        }
        
        
        do {
            print("two")
            let users = try self.database1.prepare(self.usersTable)
            for user in users {
                //print("userNumber: \(user[self.number])")
                
                let name = user[self.names]
                
                let edit = UIButton()
                edit.setTitle("Edit", for: .normal)
                
                //let switchBtn = UISwitch()
                let del = UIButton()
                del.setTitle("Delete", for: .normal)
                
                //switchBtn.setOn(false, animated: true)
                groupDataModel.append(groupNamesModal(name: name,edit:edit,delBtn:del))
                
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
    
    
    @objc func edit_group(sender:UIButton){
        print("edit")
        print(sender.accessibilityIdentifier!)
        groupTable = Table(sender.accessibilityIdentifier!)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "editGroupTableViewController") as! editGroupTableViewController
        nextViewController.setTable(tableName: sender.accessibilityIdentifier!)
        self.present(nextViewController, animated: true, completion: nil)
        //fetchGroupContacts(tablename: sender.accessibilityIdentifier!)
        
        
        
        
        //self.tableView.reloadData()
        self.viewDidLoad()
        
        }
    
    @objc func delete_group(sender:UIButton){
        print("delete")
        

        print(sender.accessibilityIdentifier!)
        //print(sender.currentTitle!)
        
        print("DELETE TAPPED")
        guard let groupname = sender.accessibilityIdentifier
            //let userId = Int(userIdString)
            else { return }
        print(groupname)
        
        let user = self.usersTable.filter(self.names == groupname)
        let deleteGroup = user.delete()
        do {
            try self.database1.run(deleteGroup)
        } catch {
            print(error)
        }
        
        do {
            print("first")
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent(groupname).appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database2 = database
        } catch {
            print(error)
        }
        let user2 = self.groupTable
        let deletetable = user2.drop(ifExists: true)
        do {
            try self.database2.run(deletetable)
        } catch {
            print(error)
        }
        //self.tableView.reloadData()
        self.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        print("inside tableview function")
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupTableViewCell", for: indexPath) as! groupTableViewCell
        //var number: String
        
        //let cell = groupTableViewCell(style: .subtitle, reuseIdentifier: cellId1)
        let groupname = groupDataModel[indexPath.row].name
        print(groupname!)
        cell.temp(cN : groupname)
        cell.link = self
        
        
        cell.name.text = groupname
        cell.edit.setTitle("Edit", for: .normal)
        cell.edit.accessibilityIdentifier=cell.name.text
     
        cell.edit.addTarget(self, action:#selector(edit_group), for: .touchUpInside)
        
        cell.delBtn.setTitle("Delete", for: .normal)
        cell.delBtn.accessibilityIdentifier=cell.name.text
        
        cell.delBtn.addTarget(self, action:#selector(delete_group), for: .touchUpInside)
        
        //cell.switchBtn.setOn(false, animated: true)
        //cell.switchBtn.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
        
        return cell
    }
    
}

