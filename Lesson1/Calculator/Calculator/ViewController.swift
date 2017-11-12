//
//  ViewController.swift
//  Calculator
//
//  Created by Batyr Charyyev on 11/11/17.
//  Copyright © 2017 Batyr Charyyev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //takes one more argument as int and returns double
    // @IBAction func touchDigit(_ sender: UIButton, otherArg: Int) -> Double {
    //      self.touchDigit(aomebutton, otherArg: 5)
    //      calling myself recursively, I have to put name like otherArg for all arg except 1st
            //notice no semicolon
    //}
    
    
    //Connection:Outlet
    //Name:whatever
    //Type:UILabel
    //Storage:farketmez shu an
    @IBOutlet weak var display: UILabel!
    
    //u are not allowed to have values without initial values
    
    var userIsInTheMiddleOFTyping: Bool = false
    
    //control key drag and drop
    //Connection:Action
    //Name:whatever
    //Type:UIButton
    //Event:touchupInside
    //Argument:Sender
    @IBAction func touchDigit(_ sender: UIButton) {
        
        //var digit = sender.currentTitle
        //var gives us warning if your var is local and never changes in the other words if it is contant use let
       
        //currentTitle  is open var currentTitle: String? { get }
        // so ? indicates that it is optional type which has only two value set(associate) and notset(nul), so our associate is String
        
        // if we dont have label set it will give us nil so ! is used to get associate value
        
        let digitwrapped = sender.currentTitle!
        let digit = sender.currentTitle
        
        if userIsInTheMiddleOFTyping {
            let textCurrentlyDisplayed = display!.text!
            display!.text = textCurrentlyDisplayed + digitwrapped
        }else{
            display!.text = digitwrapped
        }
        
        userIsInTheMiddleOFTyping = true
        
        print("touched wrappedone is \(String(describing: digitwrapped))")
        print("touched one is \(String(describing: digit))")
        print("touchDigit pressed")
    }
    //same as numbers
    @IBAction func operation(_ sender: UIButton) {
        userIsInTheMiddleOFTyping=false
        //inside of this if it is string outside of it, it is nil, not defined
        if let mathsymbol = sender.currentTitle{
         
            if mathsymbol == "pi"
            {
                display.text=String(M_PI) //converted double to string
            }
        }
    }
    
}

