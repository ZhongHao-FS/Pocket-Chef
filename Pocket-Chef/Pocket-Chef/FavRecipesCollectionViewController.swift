//
//  FavRecipesCollectionViewController.swift
//  Pocket-Chef
//
//  Created by Hao Zhong on 9/28/21.
//

import UIKit
import FirebaseDatabase

private let reuseIdentifier = "RecipeCard_large"

class FavRecipesCollectionViewController: UICollectionViewController {

    var favRecipes = [RecipeCard]()
    var urlArray = [String]()
    var selectedIndex = 0
    var currentUid = ""
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        loadFavRecipes()
    }

    func loadFavRecipes() {
        self.ref.child("FavRecipes/\(currentUid)").getData(completion: {(error, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            } else if snapshot.exists() {
                for case let item as DataSnapshot in snapshot.children {
                    guard let key = Int(item.key),
                          let value = item.value as? NSDictionary,
                          let name = value["name"] as? String,
                          let type = value["type"] as? String,
                          let url = value["imageURL"] as? String
                    else {continue}
                    
                    self.favRecipes.append(RecipeCard(id: key, title: name, imageURL: url, type: type))
                    self.urlArray.append(url)
                }
                self.collectionView.reloadData()
            } else {
                print("No data available")
            }
        })
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        if let destination = segue.destination as? RecipeDetailViewController {
            // Pass the selected object to the new view controller.
            destination.displayingRecipe = self.favRecipes[self.selectedIndex]
            destination.photoURL = self.urlArray[self.selectedIndex]
        }
        
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return favRecipes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FavRecipeCollectionViewCell
    
        // Configure the cell
        cell.layer.cornerRadius = 10
        cell.nameLabel.text = favRecipes[indexPath.row].title
        cell.typeLabel.text = favRecipes[indexPath.row].type
        cell.largePhoto.image = favRecipes[indexPath.row].image
        cell.largePhoto.frame.size = CGSize(width: 348, height: 203)
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToRecipeDetail", sender: collectionView)
    }
    
    
    

}
