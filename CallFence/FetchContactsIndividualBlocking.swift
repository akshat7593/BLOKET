//
//  FetchContactsIndividualBlocking.swift
//  temp2
//
//  Created by Akshat Agrawal on 08/04/19.
//  Copyright © 2019 Akshat Agrawal. All rights reserved.
//

//
//  ViewController.swift
//  ContactsLBTA
//
//  Created by Brian Voong on 11/13/17.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
import Contacts

class FetchContactsIndividualBlocking: UITableViewController {
    
    let cellId = "cellId123123"
    
    //https://www.letsbuildthatapp.com/course_video?id=1852
    //https://www.letsbuildthatapp.com/course_video?id=1502
    // you should use Custom Delegation properly instead
    
    
    
    var favoritableContacts = [FavoritableContact]()
    
    func someMethodIWantToCall(cell: UITableViewCell) {
        //        print("Inside of ViewController now...")
        
        // we're going to figure out which name we're clicking on
        
        guard let indexPathTapped = tableView.indexPath(for: cell) else { return }
        
        let contact = twoDimensionalArray[indexPathTapped.section].names[indexPathTapped.row]
        var number1 = ""
        if(contact.contact.phoneNumbers.count>=1)
        { number1=contact.contact.phoneNumbers[0].value.stringValue}
        else{
             number1=""
        }
        //test for calling individual
        var newString = number1.components(separatedBy:CharacterSet.decimalDigits.inverted).joined(separator: "")
        
        //ends
        
        //calling starts
        let url:NSURL = NSURL(string: "telprompt://\(newString)")!
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        print(url)
        
        //ends
        
        
//        let hasFavorited = contact.hasFavorited
//        twoDimensionalArray[indexPathTapped.section].names[indexPathTapped.row].hasFavorited = !hasFavorited
//
//        //        tableView.reloadRows(at: [indexPathTapped], with: .fade)
//
//        cell.accessoryView?.tintColor = hasFavorited ? UIColor.lightGray : .red
    }
    
    var twoDimensionalArray = [ExpandableNames]()
    
    //    var twoDimensionalArray = [
    //        ExpandableNames(isExpanded: true, names: ["Amy", "Bill", "Zack", "Steve", "Jack", "Jill", "Mary"].map{ FavoritableContact(name: $0, hasFavorited: false) }),
    //        ExpandableNames(isExpanded: true, names: ["Carl", "Chris", "Christina", "Cameron"].map{ FavoritableContact(name: $0, hasFavorited: false) }),
    //        ExpandableNames(isExpanded: true, names: ["David", "Dan"].map{ FavoritableContact(name: $0, hasFavorited: false) }),
    //        ExpandableNames(isExpanded: true, names: [FavoritableContact(name: "Patrick", hasFavorited: false)]),
    //    ]
    
    private func fetchContacts() {
        print("Attempting to fetch contacts today..")
        
        let store = CNContactStore()
        
//        store.requestAccess(for: .contacts) { (granted, err) in
//            if let err = err {
//                print("Failed to request access:", err)
//                return
//            }
//
//            if granted {
//                print("Access granted")
        
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                request.sortOrder = CNContactSortOrder.givenName
                do {
                    
                    
                    
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in
                        
                        print(contact.givenName)
                        print(contact.familyName)
                        if(contact.phoneNumbers.first?.value.stringValue ?? "" != ""){
                            //print("empty")
                            self.favoritableContacts.append(FavoritableContact(contact: contact, name: contact.givenName, hasFavorited: false))
                        }
                        //print(contact.phoneNumbers.first ?? "")
                        //if(contact.phoneNumbers.first)
                        
                        
                        //                        favoritableContacts.append(FavoritableContact(name: contact.givenName + " " + contact.familyName, hasFavorited: false))
                    })
                    
                    let names = ExpandableNames(isExpanded: true, names: self.favoritableContacts)
                    self.twoDimensionalArray = [names]
                    
                } catch let err {
                    print("Failed to enumerate contacts:", err)
                }
                
//            } else {
//                print("Access denied..")
//            }
//        }
    }
    
    var showIndexPaths = false
    
    @objc func handleShowIndexPath() {
        
        
        print("Attemping reload animation of indexPaths...")
        
        // build all the indexPaths we want to reload
        var indexPathsToReload = [IndexPath]()
        
        for section in twoDimensionalArray.indices {
            for row in twoDimensionalArray[section].names.indices {
                print(section, row)
                let indexPath = IndexPath(row: row, section: section)
                indexPathsToReload.append(indexPath)
            }
        }
        
        //        for index in twoDimensionalArray[0].indices {
        //            let indexPath = IndexPath(row: index, section: 0)
        //            indexPathsToReload.append(indexPath)
        //        }
        
        showIndexPaths = !showIndexPaths
        
        let animationStyle = showIndexPaths ? UITableView.RowAnimation.right : .left
        
        tableView.reloadRows(at: indexPathsToReload, with: animationStyle)
    }
    
    override func viewWillAppear(_ animated: Bool) {

        self.viewDidLoad()
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setup seacrch controller
        
        
        
        //ends
        
        fetchContacts()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show IndexPath", style: .plain, target: self, action: #selector(handleShowIndexPath))
        
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(ContactsCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .gray
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        
        button.tag = section
        
        return button
    }
    
    @objc func handleExpandClose(button: UIButton) {
        print("Trying to expand and close section...")
        
        let section = button.tag
        
        // we'll try to close the section first by deleting the rows
        var indexPaths = [IndexPath]()
        for row in twoDimensionalArray[section].names.indices {
            print(0, row)
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = twoDimensionalArray[section].isExpanded
        twoDimensionalArray[section].isExpanded = !isExpanded
        
        button.setTitle(isExpanded ? "Open" : "Close", for: .normal)
        
        if isExpanded {
            tableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
        }
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
        //        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ContactCell
        
        let cell = ContactsCell(style: .subtitle, reuseIdentifier: cellId)
        
        cell.link = self
        
        let favoritableContact = twoDimensionalArray[indexPath.section].names[indexPath.row]
        
        cell.textLabel?.text = favoritableContact.contact.givenName + " " + favoritableContact.contact.familyName
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        cell.detailTextLabel?.text = favoritableContact.contact.phoneNumbers.first?.value.stringValue
        
        cell.accessoryView?.tintColor = favoritableContact.hasFavorited ? UIColor.red : .lightGray
        
        
        
        if showIndexPaths {
            //            cell.textLabel?.text = "\(favoritableContact.name)   Section:\(indexPath.section) Row:\(indexPath.row)"
        }
        
        return cell
    }
    
    //adding from candy
    
}



//archit test
//extension FetchContactsIndividualBlocking : UISearchResultsUpdating {
//    func filterContentForSearchText(_ searchText: String) {
//        if(searchText == "") {
//            matchingItems = []
//        }
//
//        else {
//            matchingItems = arrayOfFixes.filter { fix in
//                return fix.lowercased().contains(searchText.lowercased())
//            }
//            tableView.reloadData()
//        }
//    }
//
//    func updateSearchResults(for searchController: UISearchController) {
//        let searchText = searchController.searchBar.text
//        filterContentForSearchText(searchText!)
//        self.tableView.reloadData()
//    }
//}
//ends












