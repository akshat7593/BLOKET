////
////  fetchViewController.swift
////  temp2
////
////  Created by Akshat Agrawal on 19/02/19.
////  Copyright © 2019 Akshat Agrawal. All rights reserved.
////
//
//import UIKit
//import SQLite
//class fetchViewController: UIViewController {
//
//    var database: Connection!
//
//    let usersTable = Table("users")
//    let number = Expression<String>("number")
//    let intime = Expression<String>("intime")
//    let outtime = Expression<String>("outtime")
//    
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var segOut: UISegmentedControl!
//
//    var blacklistData:[blacklistModal] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        blacklistData.removeAll()
//        print("inside viewdidload")
//        do {
//            print("first")
//            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
//            let database = try Connection(fileUrl.path)
//            self.database = database
//        } catch {
//            print(error)
//        }
//
//
//        do {
//            print("two")
//            let users = try self.database.prepare(self.usersTable)
//            for user in users {
//                print("userNumber: \(user[self.number]), intime: \(user[self.intime]), outtime: \(user[self.outtime])")
//
//                let number = user[self.number]
//                let intime = user[self.intime]
//                let outtime = user[self.outtime]
//                let delete = UIButton()
//                //delete.setTitle("X1", for: .normal)
//                blacklistData.append(blacklistModal(number: number,intime: intime, outtime: outtime,delete:delete))
//            }
//
//        } catch {
//            print(error)
//        }
////        blacklistData = [
////            blacklistModal(number:"+919872717155", intime:"01:10", outtime:"03:10"),
////            blacklistModal(number:"+919872717154", intime:"02:10", outtime:"04:10"),
////            blacklistModal(number:"+919872717156", intime:"04:10", outtime:"06:10")
////        ]
//        // Do any additional setup after loading the view.
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        self.tableView.reloadData()
//        self.viewDidLoad()
//    }
//
//
//    @IBAction func btnSegClick(_ sender: UISegmentedControl) {
//        self.tableView.reloadData()
//        self.viewDidLoad()
//        //self.viewWillAppear(true)
//        //viewDidLoad()
//    }
//}
//
//
//
//extension fetchViewController: UITableViewDelegate, UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
//        var value=0
//        switch segOut.selectedSegmentIndex{
//        case 0:
//            value = blacklistData.count
//            break
//        case 1:
//            break
//        default:
//            break
//        }
//        return value
//    }
//
//
//    @objc func delete_cell(sender:UIButton){
//        print("delete")
//        print(sender.accessibilityIdentifier!)
//        //print(sender.currentTitle!)
//
//        print("DELETE TAPPED")
//            guard let usernumber = sender.accessibilityIdentifier
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
//        //let obj = fetchViewController()
//        //obj.tableView.reloadData()
//        //obj.viewDidLoad()
//        //obj.tableView.reloadData()
//        //self.tableView.reloadData()
//        //self.viewDidLoad()
//        //alert.addAction(action)
//        //present(alert, animated: true, completion: nil)
//
//
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
//
//        switch segOut.selectedSegmentIndex{
//        case 0:
//            //var number: String
//            cell.number.text = blacklistData[indexPath.row].number
//            cell.intime.text = blacklistData[indexPath.row].intime
//            cell.outtime.text = blacklistData[indexPath.row].outtime
//            cell.delete.setTitle("X", for: .normal)
//            cell.delete.accessibilityIdentifier=cell.number.text
//            //print(cell.delete.accessibilityIdentifier!)
//            cell.delete.addTarget(self, action:#selector(delete_cell), for: .touchUpInside)
//            break
//        case 1:
//            break
//        default:
//            break
//        }
//
//        return cell
//    }
//
//}
