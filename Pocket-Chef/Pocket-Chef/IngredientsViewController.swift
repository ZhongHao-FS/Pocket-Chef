//
//  IngredientsViewController.swift
//  Pocket-Chef
//
//  Created by Hao Zhong on 9/22/21.
//

import UIKit
import CoreData

class IngredientsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Ingredient_cell")!
        
        cell.textLabel?.text = "\(ingredientList[indexPath.row].amount) " + ingredientList[indexPath.row].name
        cell.accessoryType = .checkmark
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.none {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    
    @IBOutlet weak var ingredientTable: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cal: UILabel!
    @IBOutlet weak var carb: UILabel!
    @IBOutlet weak var sugar: UILabel!
    @IBOutlet weak var fat: UILabel!
    @IBOutlet weak var sat: UILabel!
    @IBOutlet weak var chol: UILabel!
    @IBOutlet weak var prot: UILabel!
    @IBOutlet weak var fib: UILabel!
    @IBOutlet weak var sod: UILabel!
    @IBOutlet weak var pota: UILabel!
    @IBOutlet weak var calc: UILabel!
    @IBOutlet weak var iron: UILabel!
    @IBOutlet weak var z: UILabel!
    @IBOutlet weak var va: UILabel!
    @IBOutlet weak var vc: UILabel!
    
    var id = 0
    var ingredientList = [Ingredient]()
    
    private var appDelegate: AppDelegate!
    private var managedContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadIngredients()
        addButton.layer.cornerRadius = 30
        loadNutrition()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    func loadIngredients() {
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.spoonacular.com/recipes/\(id)/ingredientWidget.json?apiKey=56113b8493f8442dae66892e54246bfa")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
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
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    guard let ingredients = json["ingredients"] as? [Any]
                    else {return}
                    for item in ingredients {
                        guard let ingredient = item as? [String: Any],
                              let name = ingredient["name"] as? String,
                              let amount = ingredient["amount"] as? [String: Any],
                              let metric = amount["metric"] as? [String: Any],
                              let value = metric["value"] as? Double
                        else { continue }
                        
                        if let unit = metric["unit"] as? String {
                            self.ingredientList.append(Ingredient(name: name, quantity: value, unit: unit))
                        } else {
                            self.ingredientList.append(Ingredient(name: name, quantity: value))
                        }
                    }
                    
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                self.ingredientTable.delegate = self
                self.ingredientTable.reloadData()
            }
        })
        
        dataTask.resume()
    }
    
    @IBAction func addToShopping(_ sender: UIButton) {
        let entityToBuy = NSEntityDescription.entity(forEntityName: "ItemToBuy", in: managedContext)

        for i in ingredientList.indices {
            if ingredientTable.cellForRow(at: IndexPath(row: i, section: 0))?.accessoryType == .checkmark {
                let newEntry = NSManagedObject(entity: entityToBuy!, insertInto: managedContext)
                newEntry.setValue(ingredientList[i].amount, forKey: "amount")
                newEntry.setValue(ingredientList[i].name, forKey: "name")
                newEntry.setValue(ingredientList[i].unit, forKey: "unit")
                
                appDelegate.saveContext()
            }
        }
    }
    
    func loadNutrition() {
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.spoonacular.com/recipes/\(id)/nutritionWidget.json?apiKey=56113b8493f8442dae66892e54246bfa")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
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
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    guard let calories = json["calories"] as? String,
                          let carbs = json["carbs"] as? String,
                          let fat = json["fat"] as? String,
                          let protein = json["protein"] as? String,
                          let bad = json["bad"] as? [Any],
                          let sat = bad[2] as? [String: Any],
                          let satfat = sat["amount"] as? String,
                          let sug = bad[4] as? [String: Any],
                          let sugar = sug["amount"] as? String,
                          let chol = bad[5] as? [String: Any],
                          let cholest = chol["amount"] as? String,
                          let sod = bad[6] as? [String: Any],
                          let sodium = sod["amount"] as? String,
                          let good = json["good"] as? [Any],
                          let c = good[2] as? [String: Any],
                          let vc = c["amount"] as? String,
                          let a = good[3] as? [String: Any],
                          let va = a["amount"] as? String,
                          let fib = good[4] as? [String: Any],
                          let fiber = fib["amount"] as? String,
                          let calc = good[6] as? [String: Any],
                          let calcium = calc["amount"] as? String
                    else {return}
                    
                    let ir = good[9] as? [String: Any]
                    let iron = ir?["amount"] as? String
                    let po = good[12] as? [String: Any]
                    let pota = po?["amount"] as? String
                    let z = good[17] as? [String: Any]
                    let zinc = z?["amount"] as? String
                    
                    self.cal.text = calories
                    self.carb.text = carbs
                    self.sugar.text = sugar
                    self.fat.text = fat
                    self.sat.text = satfat
                    self.chol.text = cholest
                    self.prot.text = protein
                    self.fib.text = fiber
                    self.sod.text = sodium
                    self.pota.text = pota
                    self.calc.text = calcium
                    self.iron.text = iron
                    self.z.text = zinc
                    self.va.text = va
                    self.vc.text = vc
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
        })
        
        dataTask.resume()
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