//
//  ViewController.swift
//  ContactsLBTA
//
//  Created by Brian Voong on 11/13/17.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
import Contacts
import CoreData
import SQLite

class AddingNewGrpTableViewController: UITableViewController {
    var database5: Connection!
    var favoritableContacts = [FavoritableContact]()
    var twoDimensionalArray = [ExpandableNames]()
    //var index : Int = 0
    var blockTable : Table!
    let number = Expression<String>("number")
    let name = Expression<String>("name")
    var tablename = ""
    let cellId = "cellId123123"
    var blockedname = [String]()
    var blockednumbers = [String]()
    
    let b_logic = Block_logic();
    func someMethodIWantToCall(cell: UITableViewCell) {
        print(blockednumbers)
        
        // we're going to figure out which name we're clicking on
        
        guard let indexPathTapped = tableView.indexPath(for: cell) else { return }
        
        let contact = twoDimensionalArray[indexPathTapped.section].names[indexPathTapped.row]
        let fname = contact.contact.givenName
        let lname = contact.contact.familyName
        let fullname = fname + " " + lname
        let num = contact.contact.phoneNumbers[0].value.stringValue
        
        if(!blockedname.contains(fullname)){
            print(fullname)
            blockedname.append(fullname)
        }
        else{
            print(fullname)
            let filterarray = blockedname.filter{ $0 != fullname }
            blockedname = filterarray
        }
        
        
        if(!blockednumbers.contains(num)){
            blockednumbers.append(num)
        }
        else{
            let filterarray = blockednumbers.filter{ $0 != num }
            blockednumbers = filterarray
        }
        
        let hasFavorited = contact.hasFavorited
        twoDimensionalArray[indexPathTapped.section].names[indexPathTapped.row].hasFavorited = !hasFavorited
        
        //        tableView.reloadRows(at: [indexPathTapped], with: .fade)
        
        cell.accessoryView?.tintColor = hasFavorited ? UIColor.lightGray : .red
        print(blockednumbers)
    }
    
    
      private func fetchContacts(){
        print("Attempting to fetch Contacts")
      
        let store = CNContactStore()
        
        //        store.requestAccess(for: .contacts) { (granted, err) in
        //            if let err=err{
        //                print("Failed to request access",err)
        //                return
        //            }
        //
        //            if granted{
        print("Access granted")
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        request.sortOrder = CNContactSortOrder.givenName
        do{
            
            try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in
                
                
                self.favoritableContacts.append(FavoritableContact(contact: contact, hasFavorited: false))
                
            })
            
            let names = ExpandableNames(isExpanded: true, names: self.favoritableContacts)
            self.twoDimensionalArray = [names]
            
        }
        catch let err{
            print("Failed to enumerate contacts:",err)
        }
        
       
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        navigationItem.title = "Contacts"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        fetchContacts()
        
        
        
        
        tableView.register(ContactCell.self, forCellReuseIdentifier: cellId)
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let button = UIButton(type: .system)
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        
        button.tag = section
        
        return button
    }
    
    @objc func handleExpandClose(button: UIButton) {
        print("Trying to expand and close section...")
        blockTable = Table(tablename)
        //directory
        do {
            
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent(tablename).appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database5 = database
            print(documentDirectory)
            print("-------")
        } catch {
            print(error)
        }
        //ends
        print("name of new group")
        print(blockTable)
        for (index,num) in blockednumbers.enumerated(){
            print(index,num)
            print(index,blockedname[index])
            
            let insertUser = self.blockTable!.insert(self.number <- num,self.name <- blockedname[index])
            do {
                try self.database5.run(insertUser)
                print("INSERTED USER")
            } catch {
                print(error)
            }
            
        }
        
        //displaying blocked numbers
        do{
            let users = try self.database5.prepare(self.blockTable!)
            for user in users {
                print("userNumber: \(user[self.number])")
                print("username: \(user[self.name])")
                //finArray.append(user[self.number])
            }
        }
        catch{
            print(error)
        }
        
        self.dismiss(animated: true, completion: nil)
        //nextViewController.makeTable(groupName: groupTextField.text!)
        //self.present(nextViewController, animated: true, completion: nil)
        //        print("fetch controller")
        //        self.viewDidLoad()
        //b_logic.block()
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return twoDimensionalArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !twoDimensionalArray[section].isExpanded {
            
            return 0
        }
        return twoDimensionalArray[section].names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ContactCell
        
        let cell = AddingnewGrpCell(style: .subtitle, reuseIdentifier: cellId)
        
        cell.link = self
        let favoritableContact = twoDimensionalArray[indexPath.section].names[indexPath.row]
        
        cell.textLabel?.text = favoritableContact.contact.givenName + " " + favoritableContact.contact.familyName
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        cell.detailTextLabel?.text = favoritableContact.contact.phoneNumbers.first?.value.stringValue
        
        cell.accessoryView?.tintColor = favoritableContact.hasFavorited ? UIColor.red : .lightGray
        
        
        return cell
    }
    
    //function for getting name of table
    func setTablename(groupName: String?){
        print("name of the group")
        print(groupName!)
        tablename=groupName!
    }
}









