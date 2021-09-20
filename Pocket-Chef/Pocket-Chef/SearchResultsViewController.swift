//
//  SearchResultsViewController.swift
//  Pocket-Chef
//
//  Created by Hao Zhong on 9/19/21.
//

import UIKit
import Foundation

class SearchResultsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return returnedRecipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Recipe_cell2", for: indexPath) as! RecipeCollectionViewCell
        var colorIndex = indexPath.item
        while colorIndex >= 4 {
            colorIndex -= 4
        }
        
        cell.backgroundColor = pallette[colorIndex]
        cell.layer.cornerRadius = 10
        cell.dishName.text = returnedRecipes[indexPath.item].title
        cell.dishPhoto.image = returnedRecipes[indexPath.item].image
        cell.dishPhoto.frame.size = CGSize(width: 135, height: 135)
        cell.dishPhoto.layer.cornerRadius = 10
        
        return cell
    }

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var carousel: UICollectionView!
    
    var keyword: String = ""
    let pallette: [UIColor] = [UIColor(red: CGFloat(208)/255.0, green: CGFloat(242)/255.0, blue: CGFloat(116)/255.0, alpha: 1.0), UIColor(red: CGFloat(254)/255.0, green: CGFloat(216)/255.0, blue: CGFloat(87)/255.0, alpha: 1.0), UIColor(red: CGFloat(252)/255.0, green: CGFloat(165)/255.0, blue: 0, alpha: 1.0), UIColor(red: CGFloat(221)/255.0, green: CGFloat(64)/255.0, blue: CGFloat(64)/255.0, alpha: 1.0)]
    var returnedRecipes = [RecipeCard]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadSearchResults(keyword)
        searchField.text = keyword
    }
    
    func loadSearchResults(_ keywords: String) {
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.spoonacular.com/recipes/complexSearch?query=\(keywords)&addRecipeInformation=true&apiKey=56113b8493f8442dae66892e54246bfa")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
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
                    guard let recipes = json["results"] as? [Any]
                    else {return}
                    for item in recipes {
                        guard let recipe = item as? [String: Any],
                              let id = recipe["id"] as? Int,
                              let title = recipe["title"] as? String,
                              let imageURL = recipe["image"] as? String
                        else { continue }
                        
                        if let types = recipe["dishTypes"] as? [String], types.count != 0 {
                            self.returnedRecipes.append(RecipeCard(id: id, title: title, imageURL: imageURL, type: types[0]))
                        } else {
                            self.returnedRecipes.append(RecipeCard(id: id, title: title, imageURL: imageURL))
                        }
                    }
                    print("data downloaded")
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                self.carousel.delegate = self
                self.carousel.reloadData()
                print("cell loaded")
            }
        })
        
        dataTask.resume()
    }
    
    @IBAction func searchTapped(_ sender: UIButton) {
        if let query = searchField.text {
            loadSearchResults(query)
        } else {
            searchField.placeholder = "Enter a new keyword to search"
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
