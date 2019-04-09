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

class contactsTableViewController: UITableViewController {
    var database: Connection!
    var favoritableContacts = [FavoritableContact]()
    var twoDimensionalArray = [ExpandableNames]()
    //var index : Int = 0
    let blockTable = Table("blocknumbers")
    let number = Expression<String>("number")
    let name = Expression<String>("name")
    
    let cellId = "cellId123123"
    var blockedname = [String]()
    var blockednumbers = [String]()

    let b_logic = Block_logic();
    func someMethodIWantToCall(cell: UITableViewCell) {

        
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
    }
    
//    func someMethodIWantToCallInsert(cell: UITableViewCell) {
//        //        print("Inside of ViewController now...")
//
//        // we're going to figure out which name we're clicking on
//
//        guard let indexPathTapped = tableView.indexPath(for: cell) else { return }
//
//        let contact = twoDimensionalArray[indexPathTapped.section].names[indexPathTapped.row]
//        let num = contact.contact.phoneNumbers.first?.value.stringValue ?? ""
//        print(type(of: num))
//        if(num != nil){
//            blockarray.append(num)
//        }
//        else{
//            print("nill")
//        }
//
//
//        let hasFavorited = contact.hasFavorited
//        twoDimensionalArray[indexPathTapped.section].names[indexPathTapped.row].hasFavorited = !hasFavorited
//
//        //        tableView.reloadRows(at: [indexPathTapped], with: .fade)
//
//        cell.accessoryView?.tintColor = hasFavorited ? UIColor.lightGray : .red
//        print(blockarray)
//    }
    
//    func someMethodIWantToCallRemove(cell: UITableViewCell) {
//        //        print("Inside of ViewController now...")
//
//        // we're going to figure out which name we're clicking on
//
//        guard let indexPathTapped = tableView.indexPath(for: cell) else { return }
//
//        let contact = twoDimensionalArray[indexPathTapped.section].names[indexPathTapped.row]
//        let num = contact.contact.phoneNumbers.first?.value.stringValue ?? ""
//        if(num != nil){
//            var filterarray = blockarray.filter{ $0 != num }
//            blockarray = filterarray
//        }
//        else{
//            print("nill")
//        }
//
//
//        let hasFavorited = contact.hasFavorited
//        twoDimensionalArray[indexPathTapped.section].names[indexPathTapped.row].hasFavorited = !hasFavorited
//
//        //        tableView.reloadRows(at: [indexPathTapped], with: .fade)
//
//        cell.accessoryView?.tintColor = hasFavorited ? UIColor.lightGray : .red
//        print(blockarray)
//    }
    
    
    
    
    
    private func fetchContacts(){
        print("Attempting to fetch Contacts")
//        making database table
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("blocknumbers").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }

        let block_table = self.blockTable.create { (table) in
            table.column(self.number, primaryKey: true)
            table.column(self.name, primaryKey: false)
        }

        do {
            try self.database.run(block_table)
            print("Created Table")
        } catch {
            print(error)
        }

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
                
//            }
//            else{
//                print("Access Denied")
//            }
//        }
        
        do {
            let users = try self.database.prepare(self.blockTable)
            for user in users {
                
                let number = user[self.number]
                let name = user[self.name]
                blockednumbers.append(number)
                blockedname.append(name)
            }

        } catch {
            print(error)
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
        button.setTitle("Block", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        
        button.tag = section
        
        return button
    }
    
    @objc func handleExpandClose(button: UIButton) {
        print("Trying to expand and close section...")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DisplayBlockedNumbers") as! DisplayBlockedNumbers
        
        //var finArray = [String]()
        //print("INSERT TAPPED")

        //self.loadView()


        //adding blocked numbers in database
        for (index,num) in blockednumbers.enumerated(){
            //print(type(of: num))
            print(index,num)
            print(index,blockedname[index])
            let insertUser = self.blockTable.insert(self.number <- num,self.name <- blockedname[index])
            do {
                try self.database.run(insertUser)
                print("INSERTED USER")
            } catch {
                print(error)
            }
            
        }

        //displaying blocked numbers
        do{
            let users = try self.database.prepare(self.blockTable)
            for user in users {
                print("userNumber: \(user[self.number])")
                print("username: \(user[self.name])")
                //finArray.append(user[self.number])
            }
        }
            catch{
                print(error)
            }
        
        //nextViewController.makeTable(groupName: groupTextField.text!)
        //self.present(nextViewController, animated: true, completion: nil)
//        print("fetch controller")
//        self.viewDidLoad()
        b_logic.block()
        
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
        
        let cell = ContactCell(style: .subtitle, reuseIdentifier: cellId)
        
        cell.link = self
        let favoritableContact = twoDimensionalArray[indexPath.section].names[indexPath.row]
        
        cell.textLabel?.text = favoritableContact.contact.givenName + " " + favoritableContact.contact.familyName
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        cell.detailTextLabel?.text = favoritableContact.contact.phoneNumbers.first?.value.stringValue
        
        cell.accessoryView?.tintColor = favoritableContact.hasFavorited ? UIColor.red : .lightGray


        return cell
    }
    

    
}








