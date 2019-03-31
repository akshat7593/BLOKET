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
    var class_block = Block_logic()
    var database: Connection!
    var favoritableContacts = [FavoritableContact]()
    var twoDimensionalArray = [ExpandableNames]()
    //var index : Int = 0
    let blockTable = Table("blocknumbers")
    let number = Expression<String>("number")
    
    let cellId = "cellId123123"
    var blockarray = [String]()
    
//    override func viewWillAppear(_ animated: Bool) {
//        print("viwWillAppear")
//        self.tableView.reloadData()
//        //self.viewDidLoad()
//    }
    
    func someMethodIWantToCallInsert(cell: UITableViewCell) {
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
        print(blockarray)
    }
    
    func someMethodIWantToCallRemove(cell: UITableViewCell) {
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
        print(blockarray)
    }
    
    
    
    
    
    private func fetchContacts(){
        print("Attempting to fetch Contacts")
        //making database table
        do {
            //let appGroupDirectoryPath = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(appGroupId)
            //let dataBaseURL = appGroupDirectoryPath!.URLByAppendingPathComponent("database.sqlite")
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("blocknumbers").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
        
        let block_table = self.blockTable.create { (table) in
            table.column(self.number, primaryKey: true)
        }
        
        do {
            try self.database.run(block_table)
            print("Created Table")
        } catch {
            print(error)
        }
        //-------------
        
        print("abc")
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
                
                do{
                    
                    
                    
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in
                        
                        //print(contact.givenName)
                        //print(contact.familyName)
                        //print(contact.phoneNumbers.first?.value.stringValue ?? "")
                        
                        self.favoritableContacts.append(FavoritableContact(contact: contact, hasFavorited: false))
                        
                    })
                    
                    let names = ExpandableNames(isExpanded: true, names: self.favoritableContacts)
                    self.twoDimensionalArray = [names]
                    print("------aceess cobereddddd--------")
                    //self.viewDidLoad()
                    //self.tableView.reloadData()
                }
                catch let err{
                    print("Failed to enumerate contacts:",err)
                }
                
//            }
//            else{
//                print("Access Denied")
//            }
//        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("contactTableView viewDidload")
        fetchContacts()
        navigationItem.title = "Contacts"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
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
        //print("Trying to expand and close section...")
        
        
        //var finArray = [String]()
        print("INSERT TAPPED")
        
        //self.loadView()
        
        
        //adding blocked numbers in database
        for num in blockarray{
            //print(type(of: num))
            let insertUser = self.blockTable.insert(self.number <- num)
            //print("teste")
            //print(insertUser)
            do {
                try self.database.run(insertUser)
                print("INSERTED USER")
            } catch {
                print(error)
            }
        }
        
        class_block.block()
        //displaying blocked numbers
        do{
            let users = try self.database.prepare(self.blockTable)
            for user in users {
                print("userNumber: \(user[self.number])")
                //finArray.append(user[self.number])
            }
        }
            catch{
                print(error)
            }
        
        print("fetch controller")
        self.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return twoDimensionalArray.count
    }
    
    override func tableView(_ tableVriew: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !twoDimensionalArray[section].isExpanded {
            return 0
        }
        
        return twoDimensionalArray[section].names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ContactCell
        
        let cell = ContactCell(style: .subtitle, reuseIdentifier: cellId)
        //error index out of range
        
        
        //index+=1
        cell.link = self
        let favoritableContact = twoDimensionalArray[indexPath.section].names[indexPath.row]
        print("0000********00000000")
        print(favoritableContact.contact.phoneNumbers[0].value.stringValue)
        cell.temp(cN : favoritableContact.contact.phoneNumbers[0].value.stringValue)
        print("0000********00000000")
        cell.textLabel?.text = favoritableContact.contact.givenName + " " + favoritableContact.contact.familyName
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        cell.detailTextLabel?.text = favoritableContact.contact.phoneNumbers.first?.value.stringValue

        
        return cell
    }
    
}








