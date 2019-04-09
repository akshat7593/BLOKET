//
//  fetchViewController.swift
//  temp2
//
//  Created by Akshat Agrawal on 19/02/19.
//  Copyright © 2019 Akshat Agrawal. All rights reserved.
//

import UIKit
import SQLite
class BlockedNumberDisplay: UIViewController {
    
    var database: Connection!
    
    let usersTable = Table("blocknumbers")
    let number = Expression<String>("number")
    
    let name = Expression<String>("name")
    //let cellId = "cellId123127"

    let b_logic = Block_logic()
    @IBOutlet weak var tableView: UITableView!
    
    var blacklistData:[blacklistModal] = []
    
    override func viewDidLoad() {
        //self.tableView.reloadData()
        super.viewDidLoad()
        blacklistData.removeAll()
        print("inside viewdidload")
        do {
            print("first")
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("blocknumbers").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
        
        
        do {
            print("two")
            let users = try self.database.prepare(self.usersTable)
            for user in users {
                print("userNumber: \(user[self.number])")
                let name = user[self.name]
                let number = user[self.number]

                let delete = UIButton()
                delete.setTitle("X", for: .normal)
                blacklistData.append(blacklistModal(number: number,name:name,delete:delete))
            }
            //print(blacklistData)

        } catch {
            print(error)
        }
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        self.viewDidLoad()
    }
    
    
    
}

//override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//    let button = UIButton(type: .system)
//    button.setTitle("Block", for: .normal)
//    button.setTitleColor(.white, for: .normal)
//    button.backgroundColor = .black
//    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
//
//    //button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
//
//    button.tag = section
//    
//    return button
//}

extension BlockedNumberDisplay: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        print("count of table view")
        self.viewDidLoad()
        print(blacklistData.count)
        return blacklistData.count
    }
    
    
    @objc func delete_cell(sender:UIButton){
        print("delete")
        print(sender.accessibilityIdentifier!)
        //print(sender.currentTitle!)
        
        print("DELETE TAPPED")
        guard let usernumber = sender.accessibilityIdentifier
            //let userId = Int(userIdString)
            else { return }
        print(usernumber)
        
        let user = self.usersTable.filter(self.number == usernumber)
        let deleteUser = user.delete()
        do {
            try self.database.run(deleteUser)
        } catch {
            print(error)
        }

        self.tableView.reloadData()
        self.viewDidLoad()
        
        b_logic.block()
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        print("inside tableview function")
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
            //var number: String
        
        
        cell.number.text = blacklistData[indexPath.row].number
        cell.name.text = blacklistData[indexPath.row].name
        cell.delete.setTitle("X", for: .normal)
        cell.delete.accessibilityIdentifier=cell.number.text
            //print(cell.delete.accessibilityIdentifier!)
        cell.delete.addTarget(self, action:#selector(delete_cell), for: .touchUpInside)
  
        
        return cell
    }
    
}

























////
////  FirstViewController.swift
////  temp2
////
////  Created by Akshat Agrawal on 28/01/19.
////  Copyright © 2019 Akshat Agrawal. All rights reserved.
////
//
//import UIKit
//import CoreData
//import SQLite
//class FirstViewController: UIViewController {
//    var database: Connection!
//
//    let usersTable = Table("users")
//    let number = Expression<String>("number")
//    var intime = Expression<String>("intime")
//    var outtime = Expression<String>("outtime")
//
//    private var datePicker: UIDatePicker?
//    private var datePicker1: UIDatePicker?
//    private var time_var:String?
//    private var time_var1:String?
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        datePicker = UIDatePicker()
//        datePicker?.datePickerMode = .time
//        datePicker?.addTarget(self, action:#selector(dateChanged(datePicker:)), for: .valueChanged)
//        datePicker1 = UIDatePicker()
//        datePicker1?.datePickerMode = .time
//        datePicker1?.addTarget(self, action:#selector(dateChanged1(datePicker1:)), for: .valueChanged)
//
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer: )))
//        view.addGestureRecognizer(tapGesture)
//        //inputTextField.inputView = datePicker
//
//        do {
//            //let appGroupDirectoryPath = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(appGroupId)
//            //let dataBaseURL = appGroupDirectoryPath!.URLByAppendingPathComponent("database.sqlite")
//            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
//            let database = try Connection(fileUrl.path)
//            self.database = database
//        } catch {
//            print(error)
//        }
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//
//
//    @IBAction func createTable(_ sender: UIButton) {
//        print("create pressed")
//
//        let createTable = self.usersTable.create { (table) in
//            table.column(self.number, primaryKey: true)
//            table.column(self.intime)
//            table.column(self.outtime)
//        }
//
//        do {
//            try self.database.run(createTable)
//            print("Created Table")
//        } catch {
//            print(error)
//        }
//    }
//
//    @IBAction func insertIntoTable(_ sender: UIButton) {
//        var finArray = [String]()
//        print("INSERT TAPPED")
//        let alert = UIAlertController(title: "Insert User", message: nil, preferredStyle: .alert)
//        alert.addTextField { (tf) in tf.placeholder = "Number" }
//        alert.addTextField { (tf) in tf.placeholder = "InTime(HH:MM)" }
//        alert.addTextField { (tf) in tf.placeholder = "OutTime(HH:MM)" }
//
//        alert.textFields![1].inputView = datePicker
//
//        self.loadView()
//        alert.textFields![2].inputView = datePicker1
//        let action = UIAlertAction(title: "Submit", style: .default) { (_) in
//            guard let number = alert.textFields![0].text,
//
//                let intime = self.time_var,
//                let outtime = self.time_var1
//                else { return }
//            print(number)
//            print(intime)
//            print(outtime)
//
//            let insertUser = self.usersTable.insert(self.number <- number, self.intime <- intime, self.outtime <- outtime)
//            print(insertUser)
//            do {
//                try self.database.run(insertUser)
//                let users = try self.database.prepare(self.usersTable)
//                for user in users {
//                    print("userNumber: \(user[self.number]), intime: \(user[self.intime]), outtime: \(user[self.outtime])")
//                    finArray.append(user[self.number])
//                }
//                self.time_var = " "
//                self.time_var1 = " "
//                alert.textFields![2].text = " "
//
//                print(finArray)
//                let defaults = UserDefaults.standard
//                defaults.set(finArray, forKey: "block_number1")
//                print("INSERTED USER")
//            } catch {
//                print(error)
//            }
//            print("fetch controller")
//            var fc=fetchViewController()
//            fc.viewDidLoad()
//
//        }
//        alert.addAction(action)
//        present(alert, animated: true, completion: nil)
//
//    }
//
//
//    @IBAction func fetchData(_ sender: UIButton) {
//        print("fetch pressed")
//        var finArray = [String]()
//        do {
//            let users = try self.database.prepare(self.usersTable)
//            for user in users {
//                print("userNumber: \(user[self.number]), intime: \(user[self.intime]), outtime: \(user[self.outtime])")
//                finArray.append(user[self.number])
//            }
//            print(finArray)
//            let defaults = UserDefaults.standard
//            defaults.set(finArray, forKey: "block_number1")
//
//        } catch {
//            print(error)
//        }
//    }
//
//
//    @IBAction func updateData(_ sender: UIButton) {
//        print("UPDATE TAPPED")
//        let alert = UIAlertController(title: "Update User", message: nil, preferredStyle: .alert)
//        alert.addTextField { (tf) in tf.placeholder = "number" }
//        alert.addTextField { (tf) in tf.placeholder = "intime" }
//        alert.addTextField { (tf) in tf.placeholder = "outtime" }
//        let action = UIAlertAction(title: "Submit", style: .default) { (_) in
//            guard let number = alert.textFields![0].text,
//                let intime = alert.textFields![1].text,
//                let outtime = alert.textFields![2].text
//                else { return }
//            print(number)
//            print(intime)
//            print(outtime)
//
//            let user = self.usersTable.filter(self.number == number)
//
//            if intime.isEmpty && outtime.isEmpty {
//
//            }
//            else if intime.isEmpty && !outtime.isEmpty {
//                let updateUser = user.update(self.outtime <- outtime)
//                do {
//                    try self.database.run(updateUser)
//
//                } catch {
//                    print(error)
//                }
//            }
//            else if outtime.isEmpty && !intime.isEmpty {
//                let updateUser = user.update(self.intime <- intime)
//                do {
//                    try self.database.run(updateUser)
//                } catch {
//                    print(error)
//                }
//            }
//            else{
//                let updateUser = user.update(self.intime <- intime, self.outtime <- outtime)
//                do {
//                    try self.database.run(updateUser)
//                } catch {
//                    print(error)
//                }
//            }
//            var finArray = [String]()
//            do{let users = try self.database.prepare(self.usersTable)
//                for user in users {
//                    print("userNumber: \(user[self.number]), intime: \(user[self.intime]), outtime: \(user[self.outtime])")
//                    finArray.append(user[self.number])
//                }
//                print(finArray)
//                let defaults = UserDefaults.standard
//                defaults.set(finArray, forKey: "block_number1")
//            }catch{
//                print(error)
//            }
//  }
//
//        alert.addAction(action)
//        present(alert, animated: true, completion: nil)
//    }
//
//
//    @IBAction func deleteUser(_ sender: UIButton) {
//        print("DELETE TAPPED")
//        let alert = UIAlertController(title: "Update User", message: nil, preferredStyle: .alert)
//        alert.addTextField { (tf) in tf.placeholder = "User Number" }
//        let action = UIAlertAction(title: "Submit", style: .default) { (_) in
//            guard let usernumber = alert.textFields![0].text
//                //let userId = Int(userIdString)
//                else { return }
//            print(usernumber)
//
//            let user = self.usersTable.filter(self.number == usernumber)
//            let deleteUser = user.delete()
//            do {
//                try self.database.run(deleteUser)
//            } catch {
//                print(error)
//            }
//        }
//        alert.addAction(action)
//        present(alert, animated: true, completion: nil)
//    }
//
//    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
//        view.endEditing(true)
//
//    }
//
//
//    @objc func dateChanged(datePicker: UIDatePicker){
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat="MM/dd/yyyy"
//        //inputTextField.text=dateFormatter.string(from: datePicker.date)
//        let date=datePicker.date
//        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
//        //print(components.hour!)
//        //print(components.minute!)
//        let time=String(components.hour!)+":"+String(components.minute!)
//        //print(datePicker.date)
//        view.endEditing(true)
//        time_var=time
//        //view.endEditing(true)
//        //return time
//    }
//
//
//    @objc func dateChanged1(datePicker1: UIDatePicker){
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat="MM/dd/yyyy"
//        //inputTextField.text=dateFormatter.string(from: datePicker.date)
//        let date=datePicker1.date
//        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
//        //print(components.hour!)
//        //print(components.minute!)
//        let time=String(components.hour!)+":"+String(components.minute!)
//        //print(datePicker.date)
//        view.endEditing(true)
//        time_var1=time
//
//        //view.endEditing(true)
//        //return time
//    }
//
//
//}
//
