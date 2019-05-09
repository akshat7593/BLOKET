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
    var black_white_state: Connection!
    var white_list: Connection!
    var black_list: Connection!
    let blockTable = Table("blocknumbers")
    let column = Expression<String>("number")
    let white_table = Table("whitenumbers")
    let enableTable = Table("enable_W_B_List")
    let action = Expression<String>("action")
    let state = Expression<Bool>("state")
    var flag = 0
    var flag1 = 0
    
    //test
    var individual_flag=0
    
    //let grp_table = showGroupsTableViewController()
    var blockarray = [String]()
    var whitearray = [String]()
    var allcontacts = [String]()
    var call_block_array = [String]()
    var grp_block_array = [String]()
    
    var individual_white_array = [String]()
    var combined_grp_array = [String]()
    
    //array and flag variable for individual whitelisting combined
    var grp_flag = 0
    var grp_white_array = [String]()
    
    //ends
    
    //Logic for group Blocking
    func grp_block(){
        print("............check grp blocking..........")
        let defaults = UserDefaults(suiteName: "group.tag.number")
        let array = defaults!.object(forKey: "grp_block_array") as? [String] ?? [String]()
        allcontacts = defaults!.object(forKey: "all_number") as? [String] ?? [String]()
        print(array)
        flag1 = 0
        //check whether white,black or nothing enable
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("enable_W_B_List").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.black_white_state = database
        } catch {
            print(error)
        }
        
        do {
            let users = try self.black_white_state.prepare(self.enableTable)
            for user in users {
                
                let action = user[self.action]
                let state = user[self.state]
                
                if(action=="WhiteListGroup"){
                    if(state == true){
                        flag1 = 1
                    }
                }
                if(action=="BlackListGroup"){
                    if(state == true){
                        flag1 = 2
                    }
                }
                if(action=="WhiteList"){
                    if(state == true){
                        individual_flag = 1
                    }
                }
            }
        }catch{
            print(error)
        }
        //data of individual whitelisting
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("whitenumbers").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.white_list = database
        } catch {
            print(error)
        }
        do{
            individual_white_array = []
            let users = try self.white_list.prepare(self.white_table)
            for user in users {
                //print("userNumber: \(user[self.column])")
                //                blockarray.append(Int64(user[self.column].filter{ !" ".characters.contains($0)})!)
                individual_white_array.append(user[self.column])
            }
        }
        catch{
            print(error)
        }
        //ends
        //ends
        
        //updating
        if(individual_flag == 1){
            combined_grp_array = array
            for number in individual_white_array{
                combined_grp_array.append(number)
            }
        }
        else{
            combined_grp_array = array
        }
        print("value in combined array................")
        print(combined_grp_array)
        print(combined_grp_array.count)
        grp_block_array = []
        switch flag1 {
        case 0:
            grp_block_array = []
            break
        case 1:
            var check = 0
            for number in allcontacts{
                check = 0
                for num in combined_grp_array{
                    if(number == num){
                        check = 1
                    }
                }
                if(check == 0){
                    grp_block_array.append(number)
                }
            }
            break
        case 2:
            grp_block_array = array
            break
        default:
            break
        }
        print("value of group contacts blocked and total")
        print(flag1)
        print(allcontacts.count)
        print(grp_block_array.count)
        
        //entry in core data starts
        //let defaults = UserDefaults(suiteName: "group.tag.number")
        defaults!.setValue(grp_block_array, forKey: "grp_directory_array")
        defaults!.setValue(combined_grp_array, forKey: "grp_whitelist_array")
        defaults!.setValue(flag1, forKey: "flag_group_black")
        //flag_individual_group
        
        //grp_blocklist_array
        //ends
        
        //reloading extension
        CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: "com.akshat.CallFence.Call-grp-blocking", completionHandler: {(error) -> Void in if let error = error {
            print("akshat in block logic for group"+error.localizedDescription)
            }})
        //ends
    }
    //ends
    
    //function for white list and blacklist for individual
    func black_white(){
        flag = 0
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("enable_W_B_List").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.black_white_state = database
        } catch {
            print(error)
        }
        
        do {
            let users = try self.black_white_state.prepare(self.enableTable)
            for user in users {
                
                let action = user[self.action]
                let state = user[self.state]
                
                if(action=="WhiteList"){
                    if(state == true){
                        flag = 1
                    }
                }
                if(action=="BlackList"){
                    if(state == true){
                        flag = 2
                    }
                }
                
                if(action=="WhiteListGroup"){
                    if(state == true){
                        grp_flag = 1
                    }
                }
                
            }
        }catch{
            print(error)
        }
        //fetching numbers
        //first fetch list of all contact numbers
        let defaults = UserDefaults(suiteName: "group.tag.number")
        
        let array = defaults!.object(forKey: "grp_block_array") as? [String] ?? [String]()
        
        
        allcontacts = defaults!.object(forKey: "all_number") as? [String] ?? [String]()
        //print(allcontacts)
        //fetching all whitelist numbers
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("whitenumbers").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.white_list = database
        } catch {
            print(error)
        }
        do{
            whitearray=[]
            let users = try self.white_list.prepare(self.white_table)
            for user in users {
                //print("userNumber: \(user[self.column])")
                //                blockarray.append(Int64(user[self.column].filter{ !" ".characters.contains($0)})!)
                whitearray.append(user[self.column])
            }
        }
        catch{
            print(error)
        }
        //print(whitearray)
        //ends
        
        //fetching all blacklist numbers
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("blocknumbers").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.black_list = database
        } catch {
            print(error)
        }
        do{
            blockarray=[]
            let users = try self.black_list.prepare(self.blockTable)
            for user in users {
                //print("userNumber: \(user[self.column])")
                //                blockarray.append(Int64(user[self.column].filter{ !" ".characters.contains($0)})!)
                blockarray.append(user[self.column])
            }
        }
        catch{
            print(error)
        }
        //print(blockarray)
        
        //ends
        
        //grp check of both
        if(grp_flag == 1){
            grp_white_array = whitearray
            for number in array{
                grp_white_array.append(number)
            }
        }
        else{
            grp_white_array = whitearray
        }
        //ends
        
        
        //ends
        call_block_array = []
        switch flag {
        case 0:
            call_block_array = []
            break
        case 1:
            var check = 0
            for number in allcontacts{
                check = 0
                for num in grp_white_array{
                    if(number == num){
                        check = 1
                    }
                }
                if(check == 0){
                    call_block_array.append(number)
                }
            }
            break
        case 2:
            call_block_array = blockarray
            break
        default:
            break
        }
        print("count of number in white list------------")
        print(call_block_array.count)
        print("count of all numbers------------")
        print(allcontacts.count)
        print(call_block_array)
        
        //entry in core data starts
        //let defaults = UserDefaults(suiteName: "group.tag.number")
        defaults!.setValue(call_block_array, forKey: "block_array")
        defaults!.setValue(grp_white_array, forKey: "individual_whitelist_array")
        defaults!.setValue(flag, forKey: "flag_individual_black")
        //ends
        
        //reloading extension
        CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: "com.akshat.CallFence.Call-Blocking", completionHandler: {(error) -> Void in if let error = error {
            print("akshat in block_logic for individual"+error.localizedDescription)
            }})
        
    }
    
    //ends
}
