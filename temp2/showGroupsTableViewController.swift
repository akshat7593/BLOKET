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
    var database3: Connection!
    let usersTable = Table("GroupNameTable")
    let names = Expression<String>("names")
    let onoff = Expression<Bool>("onoff")
    let cellId1 = "cellId123125"
    var groupTable = Table("1")
    var groupName = Expression<String>("number")
    let b_logic = Block_logic()
    //new try
    struct GlobalVariable{
        static var myData = [MyDataObject]()
        static var blockedGroupsnumbers = [String]()
    }
    
    
    @IBOutlet weak var groupTableView: UITableView!
    
    var groupDataModel:[groupNamesModal] = []
    
    //new Class to make switch button stable
    class MyDataObject: NSObject {
        var theTitle = ""
        var theSwitchState = false
        
        init(Title title:String,state onoff: Bool) {
            theTitle = title
            theSwitchState = onoff
        }
    }
    
//    func someMethodIWantToCallT(cell: UITableViewCell) {
//        
//        
//        // we're going to figure out which name we're clicking on
//        print("T called")
//        guard let indexPathTapped = groupTableView.indexPath(for: cell) else { return }
//        print(indexPathTapped.row)
//        self.myData[indexPathTapped.row].theSwitchState = true
//        
//        //        tableView.reloadRows(at: [indexPathTapped], with: .fade)
//    }
//    
//    func someMethodIWantToCallF(cell: UITableViewCell) {
//        print("F called")
//        
//        // we're going to figure out which name we're clicking on
//        
//        guard let indexPathTapped = groupTableView.indexPath(for: cell) else { return }
//        print(indexPathTapped.row)
//        self.myData[indexPathTapped.row].theSwitchState = false
//        
//        //        tableView.reloadRows(at: [indexPathTapped], with: .fade)
//    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GlobalVariable.myData.removeAll()
        GlobalVariable.blockedGroupsnumbers.removeAll()
        groupDataModel.removeAll()

        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("GroupNameTable").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database1 = database
        } catch {
            print(error)
        }
        
        do {
            let users = try self.database1.prepare(self.usersTable)
            for user in users {
                let name = user[self.names]
                let onoff = user[self.onoff]
                let edit = UIButton()
                edit.setTitle("Edit", for: .normal)
                
                //let switchBtn = UISwitch()
                let del = UIButton()
                del.setTitle("Delete", for: .normal)
                
                print("--")
                print(name)
                print(onoff)
                print("--")
                //new try
            
                let d = MyDataObject(Title: name,state: onoff)
                GlobalVariable.myData.append(d)
                
                //switchBtn.setOn(false, animated: true)
                groupDataModel.append(groupNamesModal(name: name,edit:edit,delBtn:del))
                
            }
            
        } catch {
            print(error)
        }
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.groupTableView.reloadData()
        self.viewDidLoad()
    }
    
    
    
    
    
    //function to update myData array after preesing Done button
    @objc func handleExpandClose(button: UIButton) {
        GlobalVariable.blockedGroupsnumbers.removeAll()
        for index in GlobalVariable.myData{
            if(index.theSwitchState){
                addingNumbers(tableName: index.theTitle)
                updatingState(groupName: index.theTitle)
            }
        }
        let defaults = UserDefaults(suiteName: "group.tag.number")
        defaults!.setValue(GlobalVariable.blockedGroupsnumbers, forKey: "grp_block_array")
        b_logic.grp_block()
    }
    
    //function to update blockednumbers array after deleting a group
    func reload(){
        GlobalVariable.blockedGroupsnumbers.removeAll()
        for index in GlobalVariable.myData{
            if(index.theSwitchState){
                addingNumbers(tableName: index.theTitle)
                //updatingState(groupName: index.theTitle)
            }
        }
        let defaults = UserDefaults(suiteName: "group.tag.number")
        defaults!.setValue(GlobalVariable.blockedGroupsnumbers, forKey: "grp_block_array")
        b_logic.grp_block()
    }
    
    //updating ON/OFF state in global GroupName Table
    func updatingState(groupName: String?){
        //let users = try self.database1.prepare(self.usersTable)
        
        let alice = self.usersTable.filter(self.names == groupName!)
        let updatedata = alice.update(self.onoff <- true)
        
        do{
            try self.database1.run(updatedata)
        }
            
        catch {
            print(error)
        }
    }
    
    //Adding numbers in blockednumbers array from all the groups whose states are ON
    func addingNumbers(tableName: String){
        groupTable = Table(tableName)
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent(tableName).appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database3 = database
        } catch {
            print(error)
        }
        
        //fetching
        do {
            let users = try self.database3.prepare(groupTable)
            for user in users {
                let number = user[self.groupName]
                GlobalVariable.blockedGroupsnumbers.append(number)
                
            }
            
        } catch {
            
            print(error)
        }
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
        //self.viewDidLoad()
        
    }
    
    @objc func delete_group(sender: UIButton, index: Int){
        print("delete")
        
        
        //print(sender.accessibilityIdentifier!)
        
        print("DELETE TAPPED")
        guard let groupname = sender.accessibilityIdentifier else { return }
        
        let user = self.usersTable.filter(self.names == groupname)
        let deleteGroup = user.delete()
        do {
            try self.database1.run(deleteGroup)
        } catch {
            print(error)
        }
        
        do {
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
        
        //removing the particular cell groupname and state from myData on pressing delete on that particular cell
        GlobalVariable.myData.remove(at: sender.tag)
        
        //function to update blockednumers array
        reload()
        
        self.groupTableView.reloadData()
        self.viewDidLoad()
        
    }
}



extension showGroupsTableViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        
        button.tag = section
        
        return button
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        self.viewDidLoad()
        return groupDataModel.count
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupTableViewCell", for: indexPath) as! groupTableViewCell
        //var number: String
        
        //let cell = groupTableViewCell(style: .subtitle, reuseIdentifier: cellId1)
        let groupname = groupDataModel[indexPath.row].name
        
        cell.temp(groupName:groupname,index: indexPath.row)
        cell.link = self
        //self.myData[indexPath.row].theSwitchState = returnAns
        
        cell.name.text = groupname
        cell.name.textColor = .black
        cell.name?.font = UIFont.boldSystemFont(ofSize: 15)
        
        cell.edit.setTitle("Edit", for: .normal)
        //cell.edit.setTitleShadowColor(.green, for: .normal)
        cell.edit.accessibilityIdentifier=cell.name.text
     
        cell.edit.addTarget(self, action:#selector(edit_group), for: .touchUpInside)
        
        cell.delBtn.setTitle("Delete", for: .normal)
        cell.delBtn.setTitleColor(.red, for: .normal)
        cell.delBtn.accessibilityIdentifier=cell.name.text
        
        cell.delBtn.tag = indexPath.row
        cell.delBtn.addTarget(self, action:#selector(delete_group), for: .touchUpInside)
        
        //cell.switchBtn.setOn(false, animated: true)
        
        
        return cell
    }
    
}

