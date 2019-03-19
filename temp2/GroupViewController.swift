//
//  GroupViewController.swift
//  temp2
//
//  Created by Akshat Agrawal on 18/03/19.
//  Copyright © 2019 Akshat Agrawal. All rights reserved.
//

import UIKit
import SQLite
class GroupViewController: UIViewController {
        let groupTextField = UITextField(frame: CGRect(x: 20, y: 100, width: 275, height: 40))
    
        var database: Connection!
        var groupNamesTable = Table("GroupNameTable")
        var gColumn = Expression<String>("names")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //groupTextField =  UITextField(frame: CGRect(x: 20, y: 100, width: 275, height: 40))
        groupTextField.placeholder = "Enter Group Name"
        groupTextField.font = UIFont.systemFont(ofSize: 15)
        groupTextField.borderStyle = UITextField.BorderStyle.roundedRect
        //sampleTextField.autocorrectionType = UITextAutocorrectionType.no
        //sampleTextField.keyboardType = UIKeyboardType.default
        //sampleTextField.returnKeyType = UIReturnKeyType.done
        groupTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        groupTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        self.view.addSubview(groupTextField)
        // Do any additional setup after loading the view.
        
        
        let addContactsbutton = UIButton()
        addContactsbutton.frame = CGRect(x: 20, y: 175, width: 150, height: 40)
        addContactsbutton.backgroundColor = UIColor.blue
        addContactsbutton.layer.cornerRadius = 5
        addContactsbutton.layer.borderWidth = 1
        addContactsbutton.layer.borderColor = UIColor.black.cgColor
        addContactsbutton.setTitle("Add Contacts ", for: .normal)
        addContactsbutton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(addContactsbutton)
            
        //----------------------
        
        do{
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("GroupNameTable").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print("abc")
            print(error)
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "groupContactsTableViewController") as! groupContactsTableViewController
        //self.navigationController?.pushViewController(nextViewController, animated: true)
        print("Arc")
        print(groupTextField.text!)
        
        if(groupTextField.text == ""){
            let alertController = UIAlertController(title: "Oops", message: "Enter Group Name", preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
                NSLog("Cancel Pressed")
            }
            
            // Add the actions
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            do{
                let users = try self.database.prepare(self.groupNamesTable)
                for user in users {
                    print("Name: \(user[self.gColumn])")
                    if(groupTextField.text! == user[self.gColumn]){
                        let alertController = UIAlertController(title: "Oops", message: "Group already exists", preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            NSLog("OK Pressed")
                        }
                        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                            UIAlertAction in
                            NSLog("Cancel Pressed")
                        }
                        
                        // Add the actions
                        alertController.addAction(okAction)
                        alertController.addAction(cancelAction)
                        
                        // Present the controller
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else{
                        nextViewController.makeTable(groupName: groupTextField.text!)
                        self.present(nextViewController, animated: true, completion: nil)
                    }
                }
            }
            catch{
                print(error)
            }
        }
        
        
        
        
        

    }
    

}
