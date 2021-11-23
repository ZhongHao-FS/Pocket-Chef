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
import CryptoKit

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated {
            let kvMessage: [String: Any] = ["getObjectList": true]
            if let session = self.session, session.isReachable {
                session.sendMessage(kvMessage, replyHandler: {
                    replyData in
                        print(replyData)
                        DispatchQueue.main.async {
                            if let data = replyData["passObjectList"] as? Data{
                                do {
                                    guard let instructions = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String]
                                    else {
                                        fatalError("Cannot get Instruction array")
                                    }
                                    
                                    self.instructions = instructions
                                } catch {
                                    fatalError("Cannot unarchive data: \(error)")
                                }
                            }
                        }
                }, errorHandler: {error in
                    print(error)
                })
            }
        }
    }
    
    fileprivate let session: WCSession? = WCSession.isSupported() ? WCSession.default:nil
    var instructions = [String]()
    
    override init() {
        super.init()
        
        session?.delegate = self
        session?.activate()
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }

}
