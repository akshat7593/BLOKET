//
//  AddingUnknownViewController.swift
//  Bloket
//
//  Created by Akshat Agrawal on 01/05/19.
//  Copyright © 2019 Akshat Agrawal. All rights reserved.
//

import UIKit

class AddingUnknownViewController: UIViewController,UITextFieldDelegate {
    let IndividualContacts = UITextField(frame: CGRect(x: 20, y: 100, width: 275, height: 40))
    let add_controller = contactsTableViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        //groupTextField =  UITextField(frame: CGRect(x: 20, y: 100, width: 275, height: 40))
        IndividualContacts.placeholder = "Enter Number"
        IndividualContacts.font = UIFont.systemFont(ofSize: 15)
        IndividualContacts.borderStyle = UITextField.BorderStyle.roundedRect
        //sampleTextField.autocorrectionType = UITextAutocorrectionType.no
        //sampleTextField.keyboardType = UIKeyboardType.default
        //sampleTextField.returnKeyType = UIReturnKeyType.done
        IndividualContacts.clearButtonMode = UITextField.ViewMode.whileEditing
        IndividualContacts.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        self.view.addSubview(IndividualContacts)
        // Do any additional setup after loading the view.
        
        
        let addContactsbutton = UIButton()
        addContactsbutton.frame = CGRect(x: 20, y: 175, width: 150, height: 40)
        addContactsbutton.backgroundColor = UIColor.blue
        addContactsbutton.layer.cornerRadius = 5
        addContactsbutton.layer.borderWidth = 1
        addContactsbutton.layer.borderColor = UIColor.black.cgColor
        addContactsbutton.setTitle("Add to Blacklist", for: .normal)
        addContactsbutton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(addContactsbutton)
        self.IndividualContacts.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("hide keyboard")
        self.view.endEditing(true)
        return false
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print(IndividualContacts.text!)
        print("add contacts")
        let currentCharacterCount = IndividualContacts.text?.count ?? 0
        let check_var = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: IndividualContacts.text!))
        //alert
        if(currentCharacterCount != 10 || check_var == false){
            let alertController = UIAlertController(title: "Oops", message: "Invalid Number!", preferredStyle: .alert)
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
        //alert ends
        else{
            print("add to blacklist")
            add_controller.AddtoBlackList_individual(number: IndividualContacts.text!)
            let alertController = UIAlertController(title: "Success", message: "Number Added", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            }
        }//function closed
        
        //return 25
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
