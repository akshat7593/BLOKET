//
//  FirstViewController.swift
//  temp2
//
//  Created by Akshat Agrawal on 28/01/19.
//  Copyright © 2019 Akshat Agrawal. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func test_transfer(_ sender: UIButton) {
        print(objtest_transfer.test_transfer())
        var copiedArray: NSArray = NSArray()
        copiedArray=objtest_transfer.results
        for i in 0...4{
            print(copiedArray[i])}
    }
    
}

