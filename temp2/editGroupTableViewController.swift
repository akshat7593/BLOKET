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
    var favoritableContacts = [FavoritableContact]()
    var twoDimensionalArray = [ExpandableNames]()
    //var index : Int = 0
    var groupTable = Table("1")
    var tabname = ""
    let column = Expression<String>("number")
    
    let cellId = "cellId12312312"
    var blockarray = [String]()
    
    func someMethodIWantToCallInsertedit(cell: UITableViewCell) {
        //        print("Inside of ViewController now...")
        
        // we're going to figure out which name we're clicking on
        
        guard let indexPathTapped = tableView.indexPath(for: cell) else { return }
        
        let contact = twoDimensionalArray[indexPathTapped.section].names[indexPathTapped.row]
        let num = contact.contact.phoneNumbers.first?.value.stringValue ?? ""
        print(type(of: num))
        if(num != nil){
            blockarray.append(num)
        }
        else{
            print("nill")
        }
        
        
        let hasFavorited = contact.hasFavorited
        twoDimensionalArray[indexPathTapped.section].names[indexPathTapped.row].hasFavorited = !hasFavorited
        
        //        tableView.reloadRows(at: [indexPathTapped], with: .fade)
        
        cell.accessoryView?.tintColor = hasFavorited ? UIColor.lightGray : .red
        print("block array from editgrouptable on aaddd")
        print(blockarray)
    }
    
    
    
    func someMethodIWantToCallRemoveedit(cell: UITableViewCell) {
        //        print("Inside of ViewController now...")
        
        // we're going to figure out which name we're clicking on
        
        guard let indexPathTapped = tableView.indexPath(for: cell) else { return }
        
        let contact = twoDimensionalArray[indexPathTapped.section].names[indexPathTapped.row]
        let num = contact.contact.phoneNumbers.first?.value.stringValue ?? ""
        if(num != nil){
            var filterarray = blockarray.filter{ $0 != num }
            blockarray = filterarray
        }
        else{
            print("nill")
        }
        
        
        let hasFavorited = contact.hasFavorited
        twoDimensionalArray[indexPathTapped.section].names[indexPathTapped.row].hasFavorited = !hasFavorited
        
        //        tableView.reloadRows(at: [indexPathTapped], with: .fade)
        
        cell.accessoryView?.tintColor = hasFavorited ? UIColor.lightGray : .red
        print("block array from editgrouptable")
        print(blockarray)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        do {
//            //let appGroupDirectoryPath = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(appGroupId)
//            //let dataBaseURL = appGroupDirectoryPath!.URLByAppendingPathComponent("database.sqlite")
//            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//            let fileUrl = documentDirectory.appendingPathComponent(tabname).appendingPathExtension("sqlite3")
//            let database = try Connection(fileUrl.path)
//            self.database = database
//        } catch {
//            print(error)
//        }
        
        //adding already added numbers into blockarray
//        do {
//            let users = try self.database.prepare(groupTable)
//            //print("check_users")
//            //print(users)
//            for user in users {
//                //print("userNumber: \(user[self.number])")
//                
//                let number = user[self.column]
//                blockarray.append(number)
//                
//            }
//            print(blockarray)
//            //print(blacklistData)
//            
//        } catch {
//            print("bb")
//            print(error)
//        }
        //print(blockarray)
        
        
        fetchContacts()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(editGroupContactCell.self, forCellReuseIdentifier: cellId)
    }
    
    private func fetchContacts(){
        print("Attempting to fetch Contacts")
        //making database table
        
        print("abc")
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) { (granted, err) in
            if let err=err{
                print("Failed to request access",err)
                return
            }
            
            if granted{
                print("Access granted")
                
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do{
                    
                    
                    
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in
                        
                        //print(contact.givenName)
                        //print(contact.familyName)
                        //print(contact.phoneNumbers.first?.value.stringValue ?? "")
                        
                        self.favoritableContacts.append(FavoritableContact(contact: contact, hasFavorited: false))
                        
                    })
                    
                    let names = ExpandableNames(isExpanded: true, names: self.favoritableContacts)
                    self.twoDimensionalArray = [names]
                    
                }
                catch let err{
                    print("Failed to enumerate contacts:",err)
                }
                
            }
            else{
                print("Access Denied")
            }
        }
    }
    // MARK: - Table view data source
    func setTable(tableName: String){
        groupTable = Table(tableName)
        tabname = tableName
        
        do {
            //let appGroupDirectoryPath = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(appGroupId)
            //let dataBaseURL = appGroupDirectoryPath!.URLByAppendingPathComponent("database.sqlite")
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent(tabname).appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
        
        //fetching
        do {
            //print("aa")
            //print(groupTable)
            let users = try self.database.prepare(groupTable)
            for user in users {
                //print("userNumber: \(user[self.number])")
                
                let number = user[self.column]
                blockarray.append(number)
                
            }
            print(blockarray)
            //print(blacklistData)
            
        } catch {
            print("bb")
            print(error)
        }
        //fetchContacts()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        button.addTarget(self, action: #selector(doneGroup), for: .touchUpInside)
        
        button.tag = section
        
        return button
    }
    
    @objc func doneGroup(button: UIButton) {
        //print("Trying to expand and close section...")


        //var finArray = [String]()
        //print("INSERT TAPPED")

        //self.loadView()

        do{
            try self.database.run(self.groupTable.delete())
        }
        catch{
            print(error)
        }
        
        
        //adding blocked numbers in database
        for num in blockarray{
            //print(type(of: num))
            var insertUser = self.groupTable.insert(self.column <- num)
            //print("teste")
            //print(insertUser)
            do {
                try self.database.run(insertUser)
                print("INSERTED USER")
            } catch {
                print(error)
            }
        }



        print("fetch controller")
        self.dismiss(animated: true, completion: nil)
//        self.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return twoDimensionalArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if !twoDimensionalArray[section].isExpanded {
            return 0
        }
        
        return twoDimensionalArray[section].names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ContactCell
        
        let cell = editGroupContactCell(style: .subtitle, reuseIdentifier: cellId)
        //cell.temp(cN : favoritableContacts[index].contact.phoneNumbers[0].value.stringValue,name: tabname)
        //index+=1
        //print(index)
        cell.link = self
        let favoritableContact = twoDimensionalArray[indexPath.section].names[indexPath.row]
        //print(favoritableContacts[0].contact.phoneNumbers[0].value.stringValue)
        cell.temp(cN : favoritableContact.contact.phoneNumbers[0].value.stringValue,name: tabname)
        cell.textLabel?.text = favoritableContact.contact.givenName + " " + favoritableContact.contact.familyName
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        cell.detailTextLabel?.text = favoritableContact.contact.phoneNumbers.first?.value.stringValue
        print("2 new")
        
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
