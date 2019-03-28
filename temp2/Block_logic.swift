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
class Block_logic{
    var database: Connection!
    
    let blockTable = Table("blocknumbers")
    let column = Expression<String>("number")
    
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
        print(blockarray)
        let defaults = UserDefaults(suiteName: "group.tag.number")
        let array = defaults!.object(forKey: "block_array") as? [String] ?? [String]()
        //defaults.set(array, forKey: "block_array")
        defaults!.setValue(blockarray, forKey: "block_array")
        print(array)
        print("0----------------00------")
        let array1 = defaults!.object(forKey: "block_array") as? [String] ?? [String]()
        print(array1)
        print("akshat")
        
    }
}
