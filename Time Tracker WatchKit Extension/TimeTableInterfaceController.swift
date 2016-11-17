//
//  TimeTableInterfaceController.swift
//  Time Tracker
//
//  Created by Mirko Cukich on 11/16/16.
//  Copyright © 2016 Digital Mirko. All rights reserved.
//

import WatchKit
import Foundation


class TimeTableInterfaceController: WKInterfaceController {
    
    @IBOutlet var table: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        table.setNumberOfRows(10, withRowType: "clockInOutRow")
        
        // runs through 10 times and says Testing123 in table
        for index in 0..<10 {
            if let rowController = table.rowController(at: index) as? ClockInOutRowController {
                
                rowController.label.setText("Testing123")
            }
            
        }
        
        
    }
    
}
