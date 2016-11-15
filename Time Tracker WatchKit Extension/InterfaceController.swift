//
//  InterfaceController.swift
//  Time Tracker WatchKit Extension
//
//  Created by Mirko Cukich on 11/13/16.
//  Copyright © 2016 Digital Mirko. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    
    @IBOutlet var topLbl: WKInterfaceLabel!
    @IBOutlet var middleLbl: WKInterfaceLabel!
    @IBOutlet var clockBtn: WKInterfaceButton!
    
    // when apps starts its set to false
    var clockedIn = false
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        updateUI(clockedIn: clockedIn)

    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func updateUI(clockedIn:Bool){
        if clockedIn {
            //Shows the UI when person's clocked in
            topLbl.setHidden(false)
            middleLbl.setText("5m 22s")
            clockBtn.setTitle("Clock-Out")
            clockBtn.setBackgroundColor(UIColor.red)
            
        } else {
            // Shows the UI when person's clocked out
            topLbl.setHidden(true)
            middleLbl.setText("Today\n3h 44m")
            clockBtn.setTitle("Clock-In")
            clockBtn.setBackgroundColor(UIColor.green)
        }
    }
    
    @IBAction func clockBtnAction() {
        if clockedIn {
//            clockedIn = false
            clockOut()
        } else {
//            clockedIn = true
            clockIn()
        }
        updateUI(clockedIn: clockedIn)
    }
    
    func clockIn(){
        clockedIn = true
        
        UserDefaults.standard.set(Date(), forKey: "clockedIn")
        UserDefaults.standard.synchronize()
    }
    
    func clockOut(){
        clockedIn = false
        
        if let clockedInDate = UserDefaults.standard.value(forKey: "clockedIn") as? Date {
//            print(clockedInDate)
            // Adding the clockIn time to the clockIns array
            if var clockIns = UserDefaults.standard.array(forKey: "clockIns") as? [Date] {
                clockIns.insert(clockedInDate, at: 0)
                // save back into User Defaults
                UserDefaults.standard.set(clockIns, forKey: "clockIns")
                
                // check if working
                print(clockIns)
            } else {
                UserDefaults.standard.set([clockedInDate], forKey: "clockIns")
            }
            // Adding the clockOut time to the clockOuts array
            if var clockOuts = UserDefaults.standard.array(forKey: "clockOuts") as? [Date] {
                clockOuts.insert(Date(), at: 0)
                // save back into User Defaults
                UserDefaults.standard.set(clockOuts, forKey: "clockOuts")
                
                // check if working
                print(clockOuts)
            } else {
                UserDefaults.standard.set([Date()], forKey: "clockOuts")
            }

            // clockedIn time set to nil, if someone looses power, powers up and still clockOut if ClockedIn
            UserDefaults.standard.set(nil, forKey: "clockedIn")
            
            
        }
        // synchronize 
        UserDefaults.standard.synchronize()
    }

}
