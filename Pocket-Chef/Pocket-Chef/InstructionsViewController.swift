//
//  InstructionsViewController.swift
//  Pocket-Chef
//
//  Created by Hao Zhong on 9/26/21.
//

import UIKit
import CoreData
import WatchConnectivity

class InstructionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    func sessionDidBecomeInactive(_ session: WCSession) {}
    
    func sessionDidDeactivate(_ session: WCSession) {}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instructions[index].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Instructions_cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = "Step \(indexPath.row + 1)"
        cell.detailTextLabel?.text = instructions[index][indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.none {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stepList: UITableView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var instructions = [[String]]()
    var titles = [String]()
    var index = 0
    var managedContext: NSManagedObjectContext!
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activate()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadCoreInstruction()
        titleLabel.text = titles[index]
        checkButtons()
        
        if WCSession.isSupported() {
            session = WCSession.default
        }
    }
    
    func sendInstruction() {
        if session?.activationState == .activated {
            let kvMessage: [String: Any] = ["passingInstructionArray": self.instructions[self.index]]
            if let session = self.session, session.isReachable {
                session.sendMessage(kvMessage, replyHandler: nil, errorHandler: {error in
                    print(error)
                })
            }
        }
    }
    
    func loadCoreInstruction() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Instruction")
        
        do {
            let results: [NSManagedObject] = try managedContext.fetch(fetchRequest)
            for obj in results {
                let steps = obj.value(forKey: "steps") as! [String]
                instructions.append(steps)
                
                let name = obj.value(forKey: "title") as! String
                titles.append(name)
            }
        } catch {
            assertionFailure()
        }
        
        DispatchQueue.main.async {
            self.index = self.instructions.count - 1
            self.stepList.reloadData()
            self.checkButtons()
            if !self.instructions[self.index].isEmpty {
                self.sendInstruction()
            }
        }
    }
    
    func checkButtons() {
        if instructions.isEmpty {
            previousButton.isEnabled = false
            nextButton.isEnabled = false
        } else {
            previousButton.isEnabled = true
            nextButton.isEnabled = true
            
            if index <= 0 {
                previousButton.isEnabled = false
            }
            if index >= instructions.count - 1 {
                nextButton.isEnabled = false
            }
        }
    }
    
    @IBAction func previousTapped(_ sender: UIButton) {
        index -= 1
        titleLabel.text = titles[index]
        stepList.reloadData()
        checkButtons()
        if !instructions[index].isEmpty {
            sendInstruction()
        }
    }
    
    @IBAction func nextTapped(_ sender: UIButton) {
        index += 1
        titleLabel.text = titles[index]
        stepList.reloadData()
        checkButtons()
        if !instructions[index].isEmpty {
            sendInstruction()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
