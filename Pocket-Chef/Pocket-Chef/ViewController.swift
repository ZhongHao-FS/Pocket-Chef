//
//  ViewController.swift
//  Pocket-Chef
//
//  Created by Hao Zhong on 9/5/21.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Recipe_cell", for: indexPath) as! RecipeCollectionViewCell
        
        cell.backgroundColor = .orange
        cell.layer.cornerRadius = 10
        
        return cell
    }
    

    @IBOutlet weak var featuredRecipes: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

