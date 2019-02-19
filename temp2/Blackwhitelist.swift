//
//  FirstViewController.swift
//  temp2
//
//  Created by Akshat Agrawal on 28/01/19.
//  Copyright © 2019 Akshat Agrawal. All rights reserved.
//

import UIKit
import CoreData
class FirstViewController: UIViewController {

    @IBOutlet weak var block_button: UIButton!
    @IBOutlet weak var block_number: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

   
    @IBAction func block_number(_ sender: UIButton) {
        let number=block_number.text!
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//
//        let entity = NSEntityDescription.entity(forEntityName: "Block", in: context)
//        let newUser = NSManagedObject(entity: entity!, insertInto: context)
//        newUser.setValue(number,forKey:"block_number")
//        //newUser.setValue(89999999999,forKey:"phone")
//        do {
//            try context.save()
//        } catch {
//            print("Failed saving")
//        }
//        let defaults = UserDefaults(suiteName: "group.tag.number")
//        defaults?.set(number, forKey: "block_number")
        print("tets")
        
     
        
        
        let defaults = UserDefaults.standard
        var array = defaults.object(forKey: "block_number1") as? [String] ?? [String]()
        print(array)
        array += [number]
        //(suiteName: "group.tag.number")
//        let def=UserDefaults.standard
//        var myarray=defaults?.stringArray(forKey:"block_number") ?? [String]()
//        myarray.append(number)
//        print(myarray)
        defaults.set(array, forKey: "block_number1")
        //defaults!.synchronize()
        
        
    }
}

