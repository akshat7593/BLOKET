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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "name") as! String)
                print(data.value(forKey: "phone")as! Int64)
            }

        } catch {

            print("Failed")
        }
    }
}


