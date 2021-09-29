//
//  FrequentListViewController.swift
//  Pocket-Chef
//
//  Created by Hao Zhong on 9/28/21.
//

import UIKit
import FirebaseDatabase

class FrequentListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FrequentList_cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = list[indexPath.row].name
        cell.detailTextLabel?.text = "\(list[indexPath.row].amount) " + list[indexPath.row].unit
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .left)
            list.remove(at: indexPath.row)
        }
    }
    
    @IBOutlet weak var frequentTable: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    var list = [Ingredient]()
    var currentUid = ""
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        saveButton.layer.cornerRadius = 30
        clearButton.layer.cornerRadius = 30
        
        ref = Database.database().reference()
        loadFrequentList()
    }
    
    func loadFrequentList() {
        self.ref.child("SavedLists/\(currentUid)").getData(completion: {(error, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            } else if snapshot.exists() {
                for case let item as DataSnapshot in snapshot.children {
                    guard let value = item.value as? NSDictionary,
                          let name = value["item"] as? String,
                          let amount = value["value"] as? Double,
                          let unit = value["unit"] as? String
                    else {continue}
                    self.list.append(Ingredient(name: name, quantity: amount, unit: unit))
                }
                self.frequentTable.reloadData()
            } else {
                print("No data available")
            }
        })
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        self.ref.child("SavedLists/\(currentUid)").removeValue()
        
        for i in 0...list.count-1 {
            self.ref.child("SavedLists").child(currentUid).child("\(i)").setValue([
                "item": list[i].name,
                "value": list[i].amount,
                "unit": list[i].unit
            ])
        }
    }
    
    @IBAction func clearTapped(_ sender: UIButton) {
        list = [Ingredient]()
        self.ref.child("SavedLists/\(currentUid)").removeValue()
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
