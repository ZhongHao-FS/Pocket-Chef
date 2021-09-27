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
    @IBOutlet weak var containerViewA: UIView!
    @IBOutlet weak var containerViewB: UIView!
    @IBOutlet weak var contentSwitch: UISegmentedControl!
    
    var displayingRecipe: RecipeCard! = nil
    var background: UIImageView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let strokeTextAttributes: [NSAttributedString.Key : Any] = [
            .strokeColor : UIColor.black,
            .strokeWidth : -5.0,
            .foregroundColor : UIColor(red: CGFloat(55)/255.0, green: CGFloat(236)/255.0, blue: CGFloat(110)/255.0, alpha: 1.0)
            ]
        nameLabel.attributedText = NSAttributedString(string: displayingRecipe.title, attributes: strokeTextAttributes)
        typeLabel.attributedText = NSAttributedString(string: displayingRecipe.type, attributes: strokeTextAttributes)
        typeLabel.textColor = UIColor.white
        
        background = UIImageView(image: displayingRecipe.image)
        background.contentMode = .scaleAspectFill
        photoView.insertSubview(background, at: 0)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.view.backgroundColor = UIColor.clear
        navigationController?.navigationBar.titleTextAttributes = strokeTextAttributes
        navigationController?.navigationBar.tintColor = UIColor(red: CGFloat(55)/255.0, green: CGFloat(236)/255.0, blue: CGFloat(110)/255.0, alpha: 1.0)
        navigationItem.title = displayingRecipe.title
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        background.bounds = photoView.bounds
        photoView.sendSubviewToBack(background)
    }
    
    @IBAction func selectionChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.containerViewA.alpha = 1
                self.containerViewB.alpha = 0
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.containerViewA.alpha = 0
                self.containerViewB.alpha = 1
            })
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if let destination = segue.destination as? IngredientsViewController {
            // Pass the selected object to the new view controller.
            destination.id = self.displayingRecipe.id
        } else if let destination = segue.destination as? InstructionTableViewController {
            destination.id = self.displayingRecipe.id
            destination.recipeName = self.displayingRecipe.title
        }
        
        
    }
    

}

