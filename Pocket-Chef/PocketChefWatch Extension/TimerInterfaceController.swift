//
//  TimerInterfaceController.swift
//  PocketChefWatch Extension
//
//  Created by Hao Zhong on 11/24/21.
//

import WatchKit
import Foundation
import UIKit


class TimerInterfaceController: WKInterfaceController {

    @IBOutlet weak var timerPicker: WKInterfacePicker!
    @IBOutlet weak var button: WKInterfaceButton!
    @IBOutlet weak var timer: WKInterfaceTimer!
    
    var pickerIndex = 0
    var started = false
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        let pickerItems: [WKPickerItem] = (1...100).map {
            let pickerItem = WKPickerItem()
            pickerItem.title = "\($0)"
            return pickerItem
        }
        timerPicker.setItems(pickerItems)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func pickerItemChanged(_ value: Int) {
        pickerIndex = value
    }
    
    @IBAction func buttonTapped() {
        if started == false {
            let pickerSec = Double(pickerIndex + 1) as TimeInterval
            let time = Date(timeIntervalSinceNow: pickerSec)
            timer.setDate(time)
            timer.start()
            
            started = true
            button.setTitle("Stop")
        } else {
            timer.stop()
            
            started = false
            button.setTitle("Start")
        }
        
    }
}
