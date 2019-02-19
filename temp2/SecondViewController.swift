//
//  SecondViewController.swift
//  temp2
//
//  Created by Akshat Agrawal on 28/01/19.
//  Copyright © 2019 Akshat Agrawal. All rights reserved.
//

import UIKit
import CoreData

var objtest_transfer=SecondViewController()
class SecondViewController: UIViewController {
    
    @IBOutlet weak var Add_contact: UIButton!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    var b=19
    var results: NSArray = ["1", "2", "3", "4", "5"]
    func test_transfer()-> Int{
        var a=10
        return a
    }
    @IBAction func Add_contact(_ sender: UIButton) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Contacts", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue("Nitin",forKey:"name")
        newUser.setValue(89999999999,forKey:"phone")
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    @IBAction func fetch(_ sender: UIButton) {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Block")
//        //request.predicate = NSPredicate(format: "age = %@", "12")
//        request.returnsObjectsAsFaults = false
//        do {
//            let result = try context.fetch(request)
//            for data in result as! [NSManagedObject] {
//                print(data.value(forKey: "block_number") as! String)
//                //print(data.value(forKey: "phone")as! Int64)
//            }
//
//        } catch {
//
//            print("Failed")
//        }
    
//        let defaults = UserDefaults(suiteName: "group.tag.number")
//        let x = defaults?.double(forKey: "block_number")
//        print(x)
        
//        var ary_Values = NSMutableArray()
//
//        if  UserDefaults.standard.value(forKey: "money") != nil
//        {
//            let arr = UserDefaults.standard.value(forKey: "money") as! NSArray
//
//            for oldObj in arr
//            {
//                ary_Values.add(oldObj)
//            }
//
//            ary_Values.add(self.showLabel.text)
//        }
//
//        UserDefaults.standard.set(ary_Values, forKey: "money")
//        UserDefaults.standard.synchronize()
    let defaults = UserDefaults.standard
        //(suiteName: "group.tag.number")
    let array = defaults.object(forKey: "block_number1") as? [String] ?? [String]()
    print(array)
//    print(defaults)
    // Check for null value before setting
//        for data in defaults! as UserDefaults{
//            let restoredValue = data!.string(forKey: "block_number");
//            print(restoredValue!)
//
//        }
        //let restoredValue = defaults!.string(forKey: "block_number");
        //print(restoredValue!)
        //let defaults = UserDefaults(suiteName: "group.tag.number")
        //let def=UserDefaults.standard
        //var myarray=defaults?.stringArray(forKey:"block_number") ?? [String]()
        //myarray.append(number)
       // print(myarray)
    }
        //myLabel.setText(restoredValue)
    
}


