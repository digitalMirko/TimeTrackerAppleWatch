//
//  DetailInterfaceController.swift
//  Time Tracker
//
//  Created by Mirko Cukich on 12/4/16.
//  Copyright © 2016 Digital Mirko. All rights reserved.
//

import WatchKit
import Foundation


class DetailInterfaceController: WKInterfaceController {
    
    
    @IBOutlet var clockInLabel: WKInterfaceLabel!
    @IBOutlet var clockOutLabel: WKInterfaceLabel!
    
    

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        if let dates = context as? [Date] {
        
        let clockIn = dates[0]
        let clockOut = dates[1]
            
        clockInLabel.setText(clockIn.description)
        clockOutLabel.setText(clockOut.description)
            
            
        }
    }

  

}
