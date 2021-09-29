//
//  ShoppingViewController.swift
//  Pocket-Chef
//
//  Created by Hao Zhong on 9/27/21.
//

import UIKit
import CoreData
import FirebaseEmailAuthUI
import FirebaseDatabase

class ShoppingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingList_cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = list[indexPath.row].name
        cell.detailTextLabel?.text = "\(list[indexPath.row].amount) " + list[indexPath.row].unit
        
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let dump = list[indexPath.row]
            let request = NSFetchRequest<NSManagedObject>(entityName: "ItemToBuy")
            request.predicate = NSPredicate(format: "name = \(dump.name)")
            
            do {
                let results: [NSManagedObject] = try managedContext.fetch(request)
                
                managedContext.delete(results[0])
                appDelegate.saveContext()
                
            } catch {
                assertionFailure()
            }
            
            tableView.deleteRows(at: [indexPath], with: .left)
            list.remove(at: indexPath.row)
        }
    }
    
    @IBOutlet weak var shoppingList: UITableView!
    @IBOutlet weak var clearButton: UIButton!
    
    var list = [Ingredient]()
    var currentUid = ""
    var handle: AuthStateDidChangeListenerHandle?
    var ref: DatabaseReference!
    
    private var appDelegate: AppDelegate!
    private var managedContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadShoppingList()
        clearButton.layer.cornerRadius = 30
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        
        ref = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener({
            auth, user in
            if let user = user {
                self.currentUid = user.uid
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    func loadShoppingList() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ItemToBuy")
        
        do {
            let results: [NSManagedObject] = try managedContext.fetch(fetchRequest)
            for obj in results {
                let name = obj.value(forKey: "name") as! String
                let amount = obj.value(forKey: "amount") as! Double
                let unit = obj.value(forKey: "unit") as! String
                
                list.append(Ingredient(name: name, quantity: amount, unit: unit))
            }
        } catch {
            assertionFailure()
        }
        
        DispatchQueue.main.async {
            self.shoppingList.reloadData()
        }
    }
    
    @IBAction func clearList(_ sender: UIButton) {
        list = [Ingredient]()
        shoppingList.reloadData()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemToBuy")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs
        
        do {
            let batchDelete = try managedContext.execute(deleteRequest) as? NSBatchDeleteResult
            guard let idArray = batchDelete?.result as? [NSManagedObjectID]
            else {return}
            
            let changes = [NSDeletedObjectsKey: idArray]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes as [AnyHashable : Any], into: [managedContext])
            appDelegate.saveContext()
        } catch {
            assertionFailure()
        }
    }
    
    @IBAction func shareTapped(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Cloud Storage", message: "Save as my frequent shopping list?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "on Firebase", style: .default, handler: {_ in
            self.saveList()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func saveList() {
        if currentUid == "" {
            tabBarController?.selectedIndex = 3
        } else {
            for i in 0...list.count-1 {
                self.ref.child("SavedLists").child(currentUid).child("\(i)").setValue([
                    "item": list[i].name,
                    "value": list[i].amount,
                    "unit": list[i].unit
                ])
            }
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
