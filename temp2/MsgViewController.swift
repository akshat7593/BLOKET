//
//  SendMsgController.swift
//  temp2
//
//  Created by Akshat Agrawal on 10/02/19.
//  Copyright © 2019 Akshat Agrawal. All rights reserved.
//

import UIKit
import MessageUI

class MsgViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    
    @IBAction func sendMsg(_ sender: UIButton) {
        print("1")
        displayMessageInterface()
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func displayMessageInterface() {
        print("2")
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.recipients = ["+918460663919"]
        composeVC.body = "I love Swift!"
        
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
        }
    }
}
