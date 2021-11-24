//
//  InterfaceController.swift
//  PocketChefWatch Extension
//
//  Created by Hao Zhong on 10/28/21.
//

import WatchKit
import Foundation
import WatchConnectivity
import UIKit

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated {
            let kvMessage: [String: Any] = ["watchReady": true]
            if let session = self.session, session.isReachable {
                session.sendMessage(kvMessage, replyHandler: nil, errorHandler: {error in
                    print(error)
                })
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let getArray = message["passingInstructionArray"] as? [String] {
            instructions = getArray
            if !getArray.isEmpty {
                stepNum.setText("Step 1")
                detail.setText(instructions[0])
                checkButtons()
            }
        }
    }
    
    @IBOutlet weak var stepNum: WKInterfaceLabel!
    @IBOutlet weak var detail: WKInterfaceLabel!
    @IBOutlet weak var previousButton: WKInterfaceButton!
    @IBOutlet weak var nextButton: WKInterfaceButton!
    
    let session: WCSession? = WCSession.isSupported() ? WCSession.default:nil
    var instructions = [String]()
    var stepIndex = 0
    
    override init() {
        super.init()
        
        previousButton.setEnabled(false)
        nextButton.setEnabled(false)
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        session?.delegate = self
        session?.activate()
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }

    func checkButtons() {
        previousButton.setEnabled(true)
        nextButton.setEnabled(true)
        
        if stepIndex <= 0 {
            previousButton.setEnabled(false)
        }
        if stepIndex > instructions.count - 2 {
            nextButton.setEnabled(false)
        }
    }
    
    @IBAction func previousTapped() {
        stepIndex -= 1
        stepNum.setText("Step \(stepIndex + 1)")
        detail.setText(instructions[stepIndex])
        checkButtons()
    }
    
    @IBAction func nextTapped() {
        stepIndex += 1
        stepNum.setText("Step \(stepIndex + 1)")
        detail.setText(instructions[stepIndex])
        checkButtons()
    }
}
