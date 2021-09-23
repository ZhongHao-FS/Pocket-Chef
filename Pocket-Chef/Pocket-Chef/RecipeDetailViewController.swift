//
//  RecipeDetailViewController.swift
//  Pocket-Chef
//
//  Created by Hao Zhong on 9/21/21.
//

import UIKit

class RecipeDetailViewController: UIViewController {

    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var swipeTabView: UIView!
    
    var displayingRecipe: RecipeCard! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.text = displayingRecipe.title
        typeLabel.text = displayingRecipe.type
        
        photoView.layer.cornerRadius = 35
        photoView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        var image = displayingRecipe.image
        image.draw(in: photoView.layer.bounds)
        if let context = UIGraphicsGetImageFromCurrentImageContext() {
            image = context
            UIGraphicsEndImageContext()
        }
        photoView.backgroundColor = UIColor(patternImage: image)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.title = displayingRecipe.title
        
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

