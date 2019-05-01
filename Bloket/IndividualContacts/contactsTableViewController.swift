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
    var database1: Connection!
    var database2: Connection!
    
    var favoritableContacts = [FavoritableContact]()
    var twoDimensionalArray = [ExpandableNames]()
    //var index : Int = 0
    let blockTable = Table("blocknumbers")
    let number = Expression<String>("number")
    let name = Expression<String>("name")
    
    
    let whiteTable = Table("whitenumbers")
    let whiteNumber = Expression<String>("number")
    let whiteName = Expression<String>("name")
    
    let enableTable = Table("enable_W_B_List")
    let action = Expression<String>("action")
    let state = Expression<Bool>("state")
    
    
    let cellId = "cellId123123"
    var blockedname = [String]()
    var blockednumbers = [String]()
    var number_contact = [String]()
    
    let dialObj = DialViewController()
    
    let b_logic = Block_logic();
    
    var NumberSet = Set<String>()
    
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
        
        print(blockednumbers)
        print("--------- new --------")
        print(blockedname)
        
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

        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("whitenumbers").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database1 = database
        } catch {
            print(error)
        }

        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("enable_W_B_List").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database2 = database
        } catch {
            print(error)
        }
//
//        //creating blacklist database table
//        let block_table = self.blockTable.create { (table) in
//            table.column(self.number, primaryKey: true)
//            table.column(self.name, primaryKey: false)
//        }
//
//        do {
//            try self.database.run(block_table)
//            print("Created Table")
//        } catch {
//            print(error)
//        }
//        //----------------------------//
//
//        //creating whitelist database table
//        let white_table = self.whiteTable.create { (table) in
//            table.column(self.whiteNumber, primaryKey: true)
//            table.column(self.whiteName, primaryKey: false)
//        }
//
//        do {
//            try self.database1.run(white_table)
//            print("Created Table")
//        } catch {
//            print(error)
//        }

        //--------------------------//
        
        //creating enableTable database table
//        let enable_table = self.enableTable.create { (table) in
//            table.column(self.action, primaryKey: true)
//            table.column(self.state, primaryKey: false)
//        }
//
//        do {
//            try self.database2.run(enable_table)
//            print("Created Table")
//        } catch {
//            print(error)
//        }
        
        //--------------------------//
        
        
        //------inserting initial states in enableTable--------//
        let insertUser = self.enableTable.insert(self.action <- "WhiteList",self.state <- false)
        let insertUser1 = self.enableTable.insert(self.action <- "BlackList",self.state <- false)
        let insertUser2 = self.enableTable.insert(self.action <- "WhiteListGroup",self.state <- false)
        let insertUser3 = self.enableTable.insert(self.action <- "BlackListGroup",self.state <- false)
            do {
                try self.database2.run(insertUser)
                try self.database2.run(insertUser1)
                try self.database2.run(insertUser2)
                try self.database2.run(insertUser3)
                print("INSERTED USER")
            } catch {
                print(error)
            }
        //-----------------------//
        
        let store = CNContactStore()
        
//        store.requestAccess(for: .contacts) { (granted, err) in
//            if let err=err{
//                print("Failed to request access",err)
//                return
//            }
//
//            if granted{
                print("Access granted1")
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                request.sortOrder = CNContactSortOrder.givenName
        
                do{
                    
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in

                        if(contact.phoneNumbers.first?.value.stringValue ?? "" != ""){
                            
                            self.favoritableContacts.append(FavoritableContact(contact: contact, name: "aks", hasFavorited: false))
                        }
                        //self.number_contact.append(contact.phoneNumbers[0].value.stringValue)
                        
                    })
                    print("no duplicate--------------------")
                    print(self.NumberSet)
                    print("---------------------------------")
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
    
    
    func addContactsinArray(){
        //print(self.twoDimensionalArray.count)
        number_contact.removeAll()
        for number in self.favoritableContacts{
            //print(index)
            //print(number.contact.phoneNumbers[0].value.stringValue)
            print(number_contact.count)
            number_contact.append(number.contact.phoneNumbers[0].value.stringValue)

            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        //self.blockedname.removeAll()
        //self.blockednumbers.removeAll()
        //self.viewDidLoad()
        //self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.blockednumbers.removeAll()
        //self.blockedname.removeAll()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        navigationItem.title = "Contacts"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        number_contact.removeAll()
        number_contact = dialObj.GlobalNumberArray
        
        fetchContacts()
        addContactsinArray()
        print("ALL contact array")
        print(number_contact.count)
        print(number_contact)
        let defaults = UserDefaults(suiteName: "group.tag.number")
        defaults!.setValue(number_contact, forKey: "all_number")
        tableView.register(ContactCell.self, forCellReuseIdentifier: cellId)
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "IndividualCustomHeader") as! IndividualCustomHeader
        headerCell.backgroundColor = UIColor.gray
        headerCell.link = self
        return headerCell
        
    }
    
    @objc func AddtoBlackList(button: UIButton) {
        
        //        self.viewDidLoad()
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
        

        b_logic.black_white()
    }
    
    @objc func AddtoWhiteList(button: UIButton){
        for (index,num) in blockednumbers.enumerated(){
            //print(type(of: num))
            print(index,num)
            print(index,blockedname[index])
            let insertUser = self.whiteTable.insert(self.whiteNumber <- num,self.whiteName <- blockedname[index])
            do {
                try self.database1.run(insertUser)
                print("INSERTED USER")
            } catch {
                print(error)
            }
            
        }
        
        //displaying blocked numbers
        do{
            let users = try self.database1.prepare(self.whiteTable)
            for user in users {
                print("userNumber: \(user[self.number])")
                print("username: \(user[self.name])")
                //finArray.append(user[self.number])
            }
        }
        catch{
            print(error)
        }
        
        b_logic.black_white()
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









