//
//  Block_logic.swift
//  temp2
//
//  Created by Akshat Agrawal on 26/03/19.
//  Copyright © 2019 Akshat Agrawal. All rights reserved.
//

import Foundation
import CoreData
import SQLite
import CallKit

class Block_logic{
    var database: Connection!
    
    let blockTable = Table("blocknumbers")
    let column = Expression<String>("number")
    //let grp_table = showGroupsTableViewController()
    var blockarray = [String]()
    func block() {
        
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
        print("Archit")
        
        do{
            blockarray=[]
            let users = try self.database.prepare(self.blockTable)
            for user in users {
                print("userNumber: \(user[self.column])")
//                blockarray.append(Int64(user[self.column].filter{ !" ".characters.contains($0)})!)
                blockarray.append(user[self.column])
            }
        }
        catch{
            print(error)
        }
        print("**************")
        //print(blockarray)
        
        //Checking regex
        var temp : Array<Int64> = []
        for item in blockarray {
            var newString = item.components(separatedBy:CharacterSet.decimalDigits.inverted).joined(separator: "")
            if(newString[newString.startIndex]=="0"){
                newString.remove(at: newString.startIndex)
            }
            if(newString.count==10){
                newString="91"+newString
            }
            if(newString.count==12){
            temp.append(Int64(newString)!)
            }
        }
        print(temp)
        //ends
        
        let defaults = UserDefaults(suiteName: "group.tag.number")
        let array = defaults!.object(forKey: "block_array") as? [String] ?? [String]()
        //defaults.set(array, forKey: "block_array")
        defaults!.setValue(blockarray, forKey: "block_array")
        print(array)
        defaults!.setValue(array, forKey: "block_array_old")
        print("0----------------00------")
        let array1 = defaults!.object(forKey: "block_array") as? [String] ?? [String]()
        print(array1)
        print("-------------------------------------")
        let array2 = defaults!.object(forKey: "block_array_old") as? [String] ?? [String]()
        print("akshat")
        print(array2)
        
        CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: "com.akshat.temp2.Call-Blocking", completionHandler: {(error) -> Void in if let error = error {
            print("akshat"+error.localizedDescription)
            }})
        
    }
    //Logic for group Blocking
    func grp_block(){
        print("............check grp blocking..........")
        let defaults = UserDefaults(suiteName: "group.tag.number")
        let array = defaults!.object(forKey: "grp_block_array") as? [String] ?? [String]()
        print("check entry of group..........")
        print(array)
        CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: "com.akshat.temp2.Call-grp-blocking", completionHandler: {(error) -> Void in if let error = error {
            print("akshat"+error.localizedDescription)
            }})
        print("check entry of group..........")
        print(array)
    }
    //ends
}
