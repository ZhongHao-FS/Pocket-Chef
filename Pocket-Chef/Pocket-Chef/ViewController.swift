//
//  ViewController.swift
//  Pocket-Chef
//
//  Created by Hao Zhong on 9/5/21.
//

import UIKit
import Foundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sampleRecipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Recipe_cell", for: indexPath) as! RecipeCollectionViewCell
        
        cell.backgroundColor = pallette[indexPath.item]
        cell.layer.cornerRadius = 10
        cell.dishName.text = sampleRecipes[indexPath.item].title
        cell.dishPhoto.image = sampleRecipes[indexPath.item].image
        cell.dishPhoto.frame.size = CGSize(width: 112, height: 112)
        
        return cell
    }
    
    @IBOutlet weak var featuredRecipes: UICollectionView!
    
    let pallette: [UIColor] = [UIColor(red: CGFloat(208)/255.0, green: CGFloat(242)/255.0, blue: CGFloat(116)/255.0, alpha: 1.0), UIColor(red: CGFloat(254)/255.0, green: CGFloat(216)/255.0, blue: CGFloat(87)/255.0, alpha: 1.0), UIColor(red: CGFloat(252)/255.0, green: CGFloat(165)/255.0, blue: 0, alpha: 1.0), UIColor(red: CGFloat(221)/255.0, green: CGFloat(64)/255.0, blue: CGFloat(64)/255.0, alpha: 1.0)]
    var sampleRecipes = [RecipeCard]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadRandomRecipes()
    }

    func loadRandomRecipes() {
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.spoonacular.com/recipes/random?number=4&apiKey=56113b8493f8442dae66892e54246bfa")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
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
                    guard let recipes = json["recipes"] as? [Any]
                    else {return}
                    for item in recipes {
                        guard let recipe = item as? [String: Any],
                              let id = recipe["id"] as? Int,
                              let title = recipe["title"] as? String,
                              let imageURL = recipe["image"] as? String,
                              let summary = recipe["summary"] as? String
                        else { continue }
                        
                        let firstSentence = String(summary.split(separator: ".")[0])
                        self.sampleRecipes.append(RecipeCard(id: id, title: title, imageURL: imageURL, summary: firstSentence))
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                self.featuredRecipes.delegate = self
                self.featuredRecipes.reloadData()
            }
        })

        dataTask.resume()
    }
}

