//
//  DialerViewController.swift
//  temp2
//
//  Created by Akshat Agrawal on 30/04/19.
//  Copyright © 2019 Akshat Agrawal. All rights reserved.
//

import Foundation
import AudioToolbox
import UIKit
import CallKit
import SQLite

class DialerViewController: UIViewController {
    var database: Connection!
    var database1: Connection!
    var database2: Connection!
    
    let blockTable = Table("blocknumbers")
    let number = Expression<String>("number")
    let name = Expression<String>("name")
    
    
    let whiteTable = Table("whitenumbers")
    let whiteNumber = Expression<String>("number")
    let whiteName = Expression<String>("name")
    
    let enableTable = Table("enable_W_B_List")
    let action = Expression<String>("action")
    let state = Expression<Bool>("state")
    
    var GlobalNumberArray = [String]()
    
    @IBOutlet weak var Dial_pad: UITextField!
    
    @IBOutlet weak var cross_outlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults(suiteName: "group.tag.number")
        defaults!.setValue(0, forKey: "flag_group_black")
        defaults!.setValue(0, forKey: "flag_individual_black")
        //------//
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
        
        //creating blacklist database table
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
        //----------------------------//
        
        //creating whitelist database table
        let white_table = self.whiteTable.create { (table) in
            table.column(self.whiteNumber, primaryKey: true)
            table.column(self.whiteName, primaryKey: false)
        }
        
        do {
            try self.database1.run(white_table)
            print("Created Table")
        } catch {
            print(error)
        }
        
        //--------------------------//
        
        //creating enableTable database table
        let enable_table = self.enableTable.create { (table) in
            table.column(self.action, primaryKey: true)
            table.column(self.state, primaryKey: false)
        }
        
        do {
            try self.database2.run(enable_table)
            print("Created Table")
        } catch {
            print(error)
        }
        
        //--------------------------//
        // Do any additional setup after loading the view.
    
    let tapGesture_cross = UITapGestureRecognizer(target: self, action: #selector (tap_cross))  //Tap function will call when user tap on button
    let longGesture_cross = UILongPressGestureRecognizer(target: self, action: #selector(long_cross))  //Long function will call when user long press on button.
    tapGesture_cross.numberOfTapsRequired = 1
    cross_outlet.addGestureRecognizer(tapGesture_cross)
    cross_outlet.addGestureRecognizer(longGesture_cross)
    }
    @objc func tap_cross(){
        Dial_pad.text = String(Dial_pad.text!.dropLast())
    }
    
    @objc func long_cross() {
        Dial_pad.text=""
    }
    
    @IBAction func Btn_append(_ sender: UIButton) {
        let digit1 = sender.currentTitle!
        
        //self.dialpad.inputView = UIView(frame: CGRect.null)
        
        switch digit1 {
            
            
        case "0" :
            
            AudioServicesPlaySystemSound(1200)
            
            print("Button pressed : \(digit1)")
            
        case "1" :
            
            AudioServicesPlaySystemSound(1201)
            print("Button pressed : \(digit1)")
            
        case "2" :
            AudioServicesPlaySystemSound(1202)
            print("Button pressed : \(digit1)")
        case "3" :
            AudioServicesPlaySystemSound(1203)
            print("Button pressed : \(digit1)")
        case "4" :
            AudioServicesPlaySystemSound(1204)
            print("Button pressed : \(digit1)")
        case "5" :
            AudioServicesPlaySystemSound(1205)
            print("Button pressed : \(digit1)")
        case "6" :
            AudioServicesPlaySystemSound(1206)
            print("Button pressed : \(digit1)")
        case "7" :
            AudioServicesPlaySystemSound(1207)
            print("Button pressed : \(digit1)")
        case "8" :
            AudioServicesPlaySystemSound(1208)
            print("Button pressed : \(digit1)")
        case "9" :
            AudioServicesPlaySystemSound(1209)
            print("Button pressed : \(digit1)")
        case "*" :
            AudioServicesPlaySystemSound(1203)
            print("Button pressed : \(digit1)")
        case "#" :
            AudioServicesPlaySystemSound(1203)
            print("Button pressed : \(digit1)")
        case "+" :
            AudioServicesPlaySystemSound(1205)
            print("Button pressed : \(digit1)")
        default:
            print("Button pressed : \(digit1)")
            
        }
        Dial_pad.text = Dial_pad.text! + digit1
    }
    
    @IBAction func call_number(_ sender: UIButton) {
        var number1: String
        number1=Dial_pad.text!
        print(number1.count)
        
        let url:NSURL = NSURL(string: "telprompt://\(number1)")!
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        print(url)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
