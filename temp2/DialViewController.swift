//
//  DialViewController.swift
//  temp2
//
//  Created by Akshat Agrawal on 28/01/19.
//  Copyright © 2019 Akshat Agrawal. All rights reserved.
//
import Foundation
import AudioToolbox
import UIKit
import CallKit
class DialViewController: UIViewController {

    @IBOutlet weak var zero_outlet: UIButton!
    @IBOutlet weak var cross_outlet: UIButton!
    
    @IBOutlet weak var dail_view: UIView!
    
    @IBOutlet weak var show_button: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (tap))  //Tap function will call when user tap on button
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(long))  //Long function will call when user long press on button.
        tapGesture.numberOfTapsRequired = 1
        zero_outlet.addGestureRecognizer(tapGesture)
        zero_outlet.addGestureRecognizer(longGesture)
        
        let tapGesture_cross = UITapGestureRecognizer(target: self, action: #selector (tap_cross))  //Tap function will call when user tap on button
        let longGesture_cross = UILongPressGestureRecognizer(target: self, action: #selector(long_cross))  //Long function will call when user long press on button.
        tapGesture_cross.numberOfTapsRequired = 1
        cross_outlet.addGestureRecognizer(tapGesture_cross)
        cross_outlet.addGestureRecognizer(longGesture_cross)
        refreshExtensionState()

        // Do any additional setup after loading the view.
    }
//    override func viewWillAppear(_ animated: Bool) {
//        refreshExtensionState()
//    }
    private func refreshExtensionState() {
        print("inside func refreshExtensionState")
        CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: "com.akshat.temp2", completionHandler: {(error) -> Void in if let error = error {
            print("akshat"+error.localizedDescription)
            }})
    }
//        
//        CXCallDirectoryManager.sharedInstance.getEnabledStatusForExtension(withIdentifier: "com.akshat.temp2.Call-Blocking", completionHandler: { (enabledStatus,error) ->
//            
//            Void in if let error = error {
//                print(error.localizedDescription)
//                
//            }
//            CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier:"com.akshat.temp2.Call-Blocking", completionHandler: {
//                (error) ->
//                
//                Void in if let error = error {
//                    print(error.localizedDescription)
//                    
//                    
//                }
//                
//                DispatchQueue.main.async {
//                    //self.hud?.hide(animated: true)
//                }
//            })
//            
//            print("No error")
//        })
////        CXCallDirectoryManager.sharedInstance.getEnabledStatusForExtension(withIdentifier: "com.akshat.temp2.Call_Blocking", completionHandler: {(status, error) -> Void in if let error = error { print(error.localizedDescription) } })
//    }
    @objc func tap() {
        dailpad.text = dailpad.text! + "0"
        //dail_view.isHidden=true;
        print("Tap happend")
    }
    
    @objc func long() {
        dailpad.text = dailpad.text! + "+"
        print("Long press")
    }
    
    @objc func tap_cross(){
        dailpad.text = String(dailpad.text!.dropLast())
    }
    
    @objc func long_cross() {
        dailpad.text=""
    }
    
    
   
    @IBOutlet weak var dailpad: UITextField!
    
    
    @IBAction func Btn_Append(_ sender: UIButton) {
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
            //AudioServicesPlaySystemSound(1203)
            print("Button pressed : \(digit1)")
        case "#" :
            //AudioServicesPlaySystemSound(1203)
            print("Button pressed : \(digit1)")
        default:
            print("Button pressed : \(digit1)")
            
        }
        dailpad.text = dailpad.text! + digit1
}
    
    @IBAction func zero_btn(_ sender: UIButton) {
        let digit1 = sender.currentTitle!
        AudioServicesPlaySystemSound(1200)
         dailpad.text = dailpad.text! + digit1
        
        
    }
    
    @IBAction func call_number(_ sender: UIButton) {
        var number1: String
        number1=dailpad.text!
        print(number1.count)
        
        let url:NSURL = NSURL(string: "telprompt://\(number1)")!
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        print(url)
        
    }
    
    @IBAction func hide_view(_ sender: UIButton) {
        dail_view.isHidden=true
        show_button.isHidden=false
    }
    
    @IBAction func show_view(_ sender: UIButton) {
        dail_view.isHidden=false
        show_button.isHidden=true
    }
    
}
