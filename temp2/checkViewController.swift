//
//  checkViewController.swift
//  temp2
//
//  Created by Akshat Agrawal on 19/03/19.
//  Copyright © 2019 Akshat Agrawal. All rights reserved.
//

import UIKit
import Contacts
import CoreData
import SQLite

class checkViewController: UIViewController {
var database: Connection!
var database1: Connection!
//let usersTable = Table("GroupNameTable")
//let names = Expression<String>("names")

let familyTable = Table("F1")
let column = Expression<String>("number")
var gname = ""
override func viewDidLoad() {
    super.viewDidLoad()
    //groupDataModel.removeAll()
    print("inside viewdidload")
//    do {
//        print("first")
//        let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
////        print("directory")
////        print(documentDirectory)
//        let fileUrl = documentDirectory.appendingPathComponent("GroupNameTable").appendingPathExtension("sqlite3")
//        //print("groupnametable")
//       // print(fileUrl)
//        let database = try Connection(fileUrl.path)
//        self.database = database
//    } catch {
//        print(error)
//    }
    //print(database)
//    do {
//        print("two")
//        let users = try self.database.prepare(self.usersTable)
//        for user in users {
//            //print("userNumber: \(user[self.number])")
//
//            let name = user[self.names]
//            gname = name
//            print(name)
//        }
//        //print(blacklistData)
//
//    } catch {
//        print(error)
//    }
    
    do {
        print("first")
        let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        print("directory1")
        print(documentDirectory)
        let fileUrl = documentDirectory.appendingPathComponent("F1").appendingPathExtension("sqlite3")
        print("F1 table")
        print(fileUrl.path)
        let database = try Connection(fileUrl.path)
        print(database)
        self.database1 = database
        print(documentDirectory)
        print("-----")
    } catch {
        print(error)
    }
    print(database1)
    do {
        print("two")
        let users1 = try self.database1.prepare(self.familyTable)
        print(users1)
        for user in users1 {
            //print("userNumber: \(user[self.number])")
            
            let number = user[self.column]
            
            print(number)
        }
        //print(blacklistData)
        
    } catch {
        print("F1--------")
        print(error)
    }
    //function()
    
    
    
    
    
    

    }
    func function(){
        
        
        
        
    }
}
//class checkViewController: UIViewController {
//
//    var database: Connection!
//    var groupNamesTable = Table("GroupNameTable")
//    var gColumn = Expression<String>("names")
//
////    @IBAction func check(_ sender: UIButton) {
////        self.viewDidLoad()
////    }
//    var tableName = ""
//
//    var Familygrouptable = Table("Family")
//    //var Friendsgrouptable = Table("Friends")
//    //var Staffgrouptable = Table("Staff")
//    //var Employeegrouptable = Table("Employee")
//    var column = Expression<String>("number")
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        do {
//            print("hey")
//            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//            let fileUrl = documentDirectory.appendingPathComponent("GroupNameTable").appendingPathExtension("sqlite3")
//            let database = try Connection(fileUrl.path)
//            self.database = database
//        } catch {
//            print("abc")
//            print(error)
//        }
//
//
//        do {
//
//            print("hey 2")
//            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//            let fileUrl = documentDirectory.appendingPathComponent("Family").appendingPathExtension("sqlite3")
//            let database = try Connection(fileUrl.path)
//            self.database = database
//        } catch {
//            print("abc")
//            print(error)
//        }
//
////        do {
////            //let appGroupDirectoryPath = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(appGroupId)
////            //let dataBaseURL = appGroupDirectoryPath!.URLByAppendingPathComponent("database.sqlite")
////            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
////            let fileUrl = documentDirectory.appendingPathComponent("Friends").appendingPathExtension("sqlite3")
////            let database = try Connection(fileUrl.path)
////            self.database = database
////        } catch {
////            print("abc")
////            print(error)
////        }
////
////        do {
////            //let appGroupDirectoryPath = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(appGroupId)
////            //let dataBaseURL = appGroupDirectoryPath!.URLByAppendingPathComponent("database.sqlite")
////            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
////            let fileUrl = documentDirectory.appendingPathComponent("Staff").appendingPathExtension("sqlite3")
////            let database = try Connection(fileUrl.path)
////            self.database = database
////        } catch {
////            print("abc")
////            print(error)
////        }
////
////        do {
////            //let appGroupDirectoryPath = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(appGroupId)
////            //let dataBaseURL = appGroupDirectoryPath!.URLByAppendingPathComponent("database.sqlite")
////            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
////            let fileUrl = documentDirectory.appendingPathComponent("Employee").appendingPathExtension("sqlite3")
////            let database = try Connection(fileUrl.path)
////            self.database = database
////        } catch {
////            print("abc")
////            print(error)
////        }
//        // Do any additional setup after loading the view.
//
//        do {
//            print("two")
//            let users = try self.database.prepare(self.groupNamesTable)
//            for user in users {
//                print("userNumber: \(user[self.gColumn])")
//
//
//            }
//            //print(blacklistData)
//
//        } catch {
//            print(error)
//        }
//        print("--------------")
//        do{
//            print("two 2")
//            let users = try self.database.prepare(self.Familygrouptable)
//            for user in users {
//                print("userNumber: \(user[self.column])")
//                //finArray.append(user[self.number])
//            }
//        }
//        catch{
//            print(error)
//        }
//        print("----------")
////        do{
////            let users = try self.database.prepare(self.Friendsgrouptable)
////            for user in users {
////                print("userNumber: \(user[self.column])")
////                //finArray.append(user[self.number])
////            }
////        }
////        catch{
////            print(error)
////        }
////        print("-----------")
////        do{
////            let users = try self.database.prepare(self.Staffgrouptable)
////            for user in users {
////                print("userNumber: \(user[self.column])")
////                //finArray.append(user[self.number])
////            }
////        }
////        catch{
////            print(error)
////        }
////        print("------------")
////        do{
////            let users = try self.database.prepare(self.Employeegrouptable)
////            for user in users {
////                print("userNumber: \(user[self.column])")
////                //finArray.append(user[self.number])
////            }
////        }
////        catch{
////            print(error)
////        }
//    }
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
//
////
////  ViewController.swift
////  ContactsLBTA
////
////  Created by Brian Voong on 11/13/17.
////  Copyright © 2017 Lets Build That App. All rights reserved.
////



    


    









