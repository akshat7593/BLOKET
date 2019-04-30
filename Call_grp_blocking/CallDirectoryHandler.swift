//
//  CallDirectoryHandler.swift
//  Call_grp_blocking
//
//  Created by Akshat Agrawal on 09/04/19.
//  Copyright © 2019 Akshat Agrawal. All rights reserved.
//

import Foundation
import CallKit

class CallDirectoryHandler: CXCallDirectoryProvider {

    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        context.delegate = self

        // Check whether this is an "incremental" data request. If so, only provide the set of phone number blocking
        // and identification entries which have been added or removed since the last time this extension's data was loaded.
        // But the extension must still be prepared to provide the full set of data at any time, so add all blocking
        // and identification phone numbers if the request is not incremental.
        if context.isIncremental {
            addOrRemoveIncrementalBlockingPhoneNumbers(to: context)
        } else {
            addAllBlockingPhoneNumbers(to: context)
        }

        context.completeRequest()
    }

    private func addAllBlockingPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        // Retrieve all phone numbers to block from data store. For optimal performance and memory usage when there are many phone numbers,
        // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
        //
        // Numbers must be provided in numerically ascending order.
        //starts own
        
        
        var finalArray = [Int64]()
        let defaults = UserDefaults(suiteName: "group.tag.number")
        let array = defaults!.object(forKey: "grp_directory_array") as? [String] ?? [String]()
        
        //list of white listed numbers
        let grp_whitelist_array = defaults!.object(forKey: "grp_whitelist_array") as? [String] ?? [String]()
        //ends
        
        //converting array to Set
        var WhiteNumberSet = Set<Int64>()
        for num in grp_whitelist_array{
            var newString = num.components(separatedBy:CharacterSet.decimalDigits.inverted).joined(separator: "")
            if(newString[newString.startIndex]=="0"){
                newString.remove(at: newString.startIndex)
            }
            if(newString.count==10){
                newString="91"+newString
            }
            if(newString.count==12){
                WhiteNumberSet.insert(Int64(newString)!)
            }
            
        }
        //var flag = Int16(-1)
        let flag = (defaults!.object(forKey: "flag_group_black") as? Int16)!
        print("value of flag for black or white")
        print(flag)
        if(flag == 2){
            WhiteNumberSet.removeAll()
        }
        
        print("array in extension..of group blocking.....")
        print(array.count)
        var temp : Array<Int64> = []
        for item in array {
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
        temp.sort()
        print("temp in extension....of group...")
        print(temp.count)
        var previous = Int64(0)
        for num in temp{
            if(num>previous && !WhiteNumberSet.contains(num)){
                finalArray.append(num)
                previous = num
            }
        }
        print(finalArray.count)
        //ends
        let allPhoneNumbers: [CXCallDirectoryPhoneNumber] = finalArray
        for phoneNumber in allPhoneNumbers {
            context.addBlockingEntry(withNextSequentialPhoneNumber: phoneNumber)
        }
    }

    private func addOrRemoveIncrementalBlockingPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        // Retrieve any changes to the set of phone numbers to block from data store. For optimal performance and memory usage when there are many phone numbers,
        // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
        
        context.removeAllBlockingEntries()
        
        //starts own
        let defaults = UserDefaults(suiteName: "group.tag.number")
        let array = defaults!.object(forKey: "grp_directory_array") as? [String] ?? [String]()
        //list of white listed numbers
        let grp_whitelist_array = defaults!.object(forKey: "grp_whitelist_array") as? [String] ?? [String]()
        //ends
        
        //converting array to Set
        var WhiteNumberSet = Set<Int64>()
        for num in grp_whitelist_array{
            var newString = num.components(separatedBy:CharacterSet.decimalDigits.inverted).joined(separator: "")
            if(newString[newString.startIndex]=="0"){
                newString.remove(at: newString.startIndex)
            }
            if(newString.count==10){
                newString="91"+newString
            }
            if(newString.count==12){
                WhiteNumberSet.insert(Int64(newString)!)
            }
            
        }
        let flag = defaults!.object(forKey: "flag_group_black") as? Int16
        print("value of flag for black or white")
        print(flag!)
        if(flag! == 2){
            WhiteNumberSet.removeAll()
        }
        print("array in extension")
        print(array)
        var finalArray = [Int64]()
        var temp : Array<Int64> = []
        for item in array {
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
        temp.sort()
        print("temp in extension of groups")
        print(temp.count)
        var previous = Int64(0)
        for num in temp{
            if(num>previous && !WhiteNumberSet.contains(num)){
                finalArray.append(num)
                previous = num
            }
        }
        //ends
        
        let phoneNumbersToAdd: [CXCallDirectoryPhoneNumber] = finalArray
        for phoneNumber in phoneNumbersToAdd {
            context.addBlockingEntry(withNextSequentialPhoneNumber: phoneNumber)
        }


        // Record the most-recently loaded set of blocking entries in data store for the next incremental load...
    }
}

extension CallDirectoryHandler: CXCallDirectoryExtensionContextDelegate {

    func requestFailed(for extensionContext: CXCallDirectoryExtensionContext, withError error: Error) {
        // An error occurred while adding blocking or identification entries, check the NSError for details.
        // For Call Directory error codes, see the CXErrorCodeCallDirectoryManagerError enum in <CallKit/CXError.h>.
        //
        // This may be used to store the error details in a location accessible by the extension's containing app, so that the
        // app may be notified about errors which occured while loading data even if the request to load data was initiated by
        // the user in Settings instead of via the app itself.
    }

}
