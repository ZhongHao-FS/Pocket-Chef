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
            
            var calories: String? = nil
            var carbs: String? = nil
            var fat: String? = nil
            var protein: String? = nil
            var satfat: String? = nil
            var sugar: String? = nil
            var cholest: String? = nil
            var sodium: String? = nil
            var vc: String? = nil
            var va: String? = nil
            var fiber: String? = nil
            var calcium: String? = nil
            var iron: String? = nil
            var pota: String? = nil
            var zinc: String? = nil
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    calories = json["calories"] as? String
                    carbs = json["carbs"] as? String
                    fat = json["fat"] as? String
                    protein = json["protein"] as? String
                    
                    guard let bad = json["bad"] as? [Any],
                          let good = json["good"] as? [Any]
                    else {return}
                    
                    for entry in bad {
                        guard let nutrition = entry as? [String: Any],
                              let title = nutrition["title"] as? String
                        else {continue}
                        
                        switch title {
                        case "Saturated Fat":
                            satfat = nutrition["amount"] as? String
                        case "Sugar":
                            sugar = nutrition["amount"] as? String
                        case "Cholesterol":
                            cholest = nutrition["amount"] as? String
                        case "Sodium":
                            sodium = nutrition["amount"] as? String
                        default:
                            continue
                        }
                    }
                    
                    for entry in good {
                        guard let nutrition = entry as? [String: Any],
                              let title = nutrition["title"] as? String
                        else {continue}
                        
                        switch title {
                        case "Vitamin C":
                            vc = nutrition["amount"] as? String
                        case "Vitamin A":
                            va = nutrition["amount"] as? String
                        case "Fiber":
                            fiber = nutrition["amount"] as? String
                        case "Calcium":
                            calcium = nutrition["amount"] as? String
                        case "Iron":
                            iron = nutrition["amount"] as? String
                        case "Potassium":
                            pota = nutrition["amount"] as? String
                        case "Zinc":
                            zinc = nutrition["amount"] as? String
                        default:
                            continue
                        }
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            DispatchQueue.main.async {
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
