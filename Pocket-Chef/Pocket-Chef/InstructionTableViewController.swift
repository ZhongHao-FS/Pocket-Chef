//
//  InstructionTableViewController.swift
//  Pocket-Chef
//
//  Created by Hao Zhong on 9/26/21.
//

import UIKit
import CoreData
import WatchConnectivity

class InstructionTableViewController: UITableViewController, WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    func sessionDidBecomeInactive(_ session: WCSession) {}
    
    func sessionDidDeactivate(_ session: WCSession) {}
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        DispatchQueue.main.async {
            if let getList = message["getObjectList"] as? Bool {
                if getList {
                    guard let data = try? NSKeyedArchiver.archivedData(withRootObject: self.instructions, requiringSecureCoding: false)
                    else {
                        fatalError("NSArchiving Error")
                    }
                    replyHandler(["passObjectList": data])
                }
            }
        }
    }
    
    var id = 0
    var instructions = [String]()
    var recipeName = ""
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activate()
            }
        }
    }
    
    private var appDelegate: AppDelegate!
    private var managedContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        loadInstructions()
        
        if WCSession.isSupported() {
            session = WCSession.default
        }
    }

    func loadInstructions() {
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.spoonacular.com/recipes/\(id)/analyzedInstructions?apiKey=56113b8493f8442dae66892e54246bfa")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (opt_data, opt_response, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            guard let response = opt_response as? HTTPURLResponse,
                  response.statusCode == 200,
                  let data = opt_data
            else {return}
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [Any] {
                    guard let instruction = json[0] as? [String: Any],
                          let steps = instruction["steps"] as? [Any]
                    else {return}
                    
                    for item in steps {
                        guard let step = item as? [String: Any],
                              let verbal = step["step"] as? String
                        else { continue }
                        
                        self.instructions.append(verbal)
                    }
                    
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                self.tableView.delegate = self
                self.tableView.reloadData()
                
                let entityInstruction = NSEntityDescription.entity(forEntityName: "Instruction", in: self.managedContext)
                let newInstruction = NSManagedObject(entity: entityInstruction!, insertInto: self.managedContext)
                newInstruction.setValue(self.id, forKey: "id")
                newInstruction.setValue(self.instructions, forKey: "steps")
                newInstruction.setValue(self.recipeName, forKey: "title")
                self.appDelegate.saveContext()
            }
        })
        
        dataTask.resume()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return instructions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Instruction_cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = "Step \(indexPath.row + 1)"
        cell.detailTextLabel?.text = instructions[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.none {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
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
