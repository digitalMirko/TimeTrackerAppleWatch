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
        
        //        totalClockedTime()
        
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
            self.topLbl.setText("Today: \(self.totalTimeWorkedAsString())")
//            middleLbl.setText("0h 0m 0s")
            middleLbl.setText("0s")
            clockBtn.setTitle("Clock-Out")
            clockBtn.setBackgroundColor(UIColor.red)
            
        } else {
            // Shows the UI when person's clocked out
            topLbl.setHidden(true)
            //            middleLbl.setText("Today\n3h 44m")
            clockBtn.setTitle("Clock-In")
            clockBtn.setBackgroundColor(UIColor.green)
            middleLbl.setText("Today\n\(totalTimeWorkedAsString())")
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
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            (timer) in
            if let clockedInDate = UserDefaults.standard.value(forKey: "clockedIn") as? Date {
                let timeInterval = Int(Date().timeIntervalSince(clockedInDate))  // + 40000 seconds for testing
                //                print(timeInterval)  // testing output
                
                let hours = timeInterval / 3600
                let minutes = (timeInterval % 3600) / 60
                let seconds = timeInterval % 60
                
                var currentClockedInString = ""
                
                if hours != 0 {
                    currentClockedInString += "\(hours)h "
                }
                
                if minutes != 0 || hours != 0 {
                    currentClockedInString += "\(minutes)m "
                }
                
                currentClockedInString += "\(seconds)s"
                
//                self.middleLbl.setText("\(hours)h \(minutes)m \(seconds)s")
                self.middleLbl.setText(currentClockedInString)
                
//                let totalTimeInterval = timeInterval + self.totalClockedTime()
                
                // updating top label
//                let totalHours = totalTimeInterval / 3600
//                let totalMinutes = (totalTimeInterval % 3600) / 60
//                let totalSeconds = totalTimeInterval % 60
//                self.topLbl.setText("Today:\(totalHours)h \(totalMinutes)m \(totalSeconds)s")
                
                self.topLbl.setText("Today: \(self.totalTimeWorkedAsString())")
            }
        }
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
        
        // calls total clocked time
        //        totalClockedTime()
    }
    
    func totalClockedTime() -> Int {
        if var clockIns = UserDefaults.standard.array(forKey: "clockIns") as? [Date] {
            if var clockOuts = UserDefaults.standard.array(forKey: "clockOuts") as? [Date] {
                
                var seconds = 0
                for index in 0..<clockIns.count {
                    
                    //                    print("ClockIn:\(clockIns[index])")      // testing
                    //                    print("ClockOut:\(clockOuts[index])")    // testing
                    
                    // Find the seconds between clockin and out
                    let currentSeconds = Int(clockOuts[index].timeIntervalSince(clockIns[index]))
                    
                    
                    // Add time to seconds
                    seconds += currentSeconds
                }
                
                //                print("Total Seconds: \(seconds)")
                return seconds
            }
        }
        return 0
    }
    
    // how much time has someone worked
    func totalTimeWorkedAsString() -> String {
        
        var currentClockedInSeconds = 0
        
        if let clockedInDate = UserDefaults.standard.value(forKey: "clockedIn") as? Date {
            currentClockedInSeconds = Int(Date().timeIntervalSince(clockedInDate))
            
        }
        
        let totalTimeInterval = currentClockedInSeconds + self.totalClockedTime()
        let totalHours = totalTimeInterval / 3600
        let totalMinutes = (totalTimeInterval % 3600) / 60
        
        return "\(totalHours)h \(totalMinutes)m"
        
    }
    
}
