//
//  editGroupTableViewController.swift
//  temp2
//
//  Created by Akshat Agrawal on 19/03/19.
//  Copyright © 2019 Akshat Agrawal. All rights reserved.
//

import UIKit
import Contacts
import CoreData
import SQLite

class editGroupTableViewController: UITableViewController {
    var database: Connection!
    //var index : Int = 0
    var groupTable = Table("1")
    var tabname = ""
    let column = Expression<String>("number")
    let nameColumn = Expression<String>("name")
    
    let cellId = "cellId12312312"
    var blockednumbers = [String]()
    var blockedname = [String]()
    
    func delete(cell: UITableViewCell) {
        
        print("delete tapped")
        // we're going to figure out which name we're clicking on
        
        guard let indexPathTapped = tableView.indexPath(for: cell) else { return }
        
        //let name = blockedname[indexPathTapped.row]
        let num = blockednumbers[indexPathTapped.row]
        
        
        let user = self.groupTable.filter(self.column == num)
        let deleteUser = user.delete()
        do {
            try self.database.run(deleteUser)
        } catch {
            print(error)
        }
        
        self.tableView.reloadData()
        self.viewDidLoad()
        //b_logic.block()
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(editGroupContactCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        self.viewDidLoad()
    }
    
    // MARK: - Table view data source
    func setTable(tableName: String){
        groupTable = Table(tableName)
        tabname = tableName
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent(tabname).appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
        
        //fetching
        do {
            let users = try self.database.prepare(groupTable)
            for user in users {
                //print("userNumber: \(user[self.number])")
                
                let number = user[self.column]
                let name = user[self.nameColumn]
                blockednumbers.append(number)
                blockedname.append(name)
                
            }
            print(blockedname)
            print(blockednumbers)
            //print(blacklistData)
            
        } catch {
            print(error)
    }
}
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "CustomHeaderCellEdit") as! CustomHeaderCellEdit
        headerCell.backgroundColor = UIColor.black
        headerCell.link = self
        return headerCell
    }
    
    @objc func doneGroup(button: UIButton) {


        print("fetch controller")
        self.dismiss(animated: true, completion: nil)
//        self.viewDidLoad()
    }
    
    @objc func addMore(button: UIButton){
        print("in addmore function")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddMoreContactsController") as! AddMoreContactsController
        nextViewController.customfunction(tableName: tabname)
        self.present(nextViewController , animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        self.viewDidLoad()
        return blockedname.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ContactCell
        
        let cell = editGroupContactCell(style: .subtitle, reuseIdentifier: cellId)
        //cell.temp(cN : favoritableContacts[index].contact.phoneNumbers[0].value.stringValue,name: tabname)
        //index+=1
        //print(index)
        cell.link = self
        //print(favoritableContacts[0].contact.phoneNumbers[0].value.stringValue)
        //cell.temp(cN : favoritableContact.contact.phoneNumbers[0].value.stringValue,name: tabname)
        cell.textLabel?.text = blockedname[indexPath.row]
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        cell.detailTextLabel?.text = blockednumbers[indexPath.row]
        
        //cell.accessoryView?.tintColor = favoritableContact.hasFavorited ? UIColor.red : .lightGray
        
        
        
        //        if showIndexPaths {
        //            //cell.textLabel?.text = "\(favoritableContact.name)   Section:\(indexPath.section) Row:\(indexPath.row)"
        //        }
        
        return cell
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
