//
//  AddRecipeViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/27/22.
//

import UIKit

class AddRecipeViewController: UIViewController {

    @IBOutlet weak var recipeImage: UIImageView!
    
    @IBOutlet weak var foodNeeded: UILabel!
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    
    @IBOutlet weak var recipeTextField: UITextField!
    
    @IBOutlet weak var foodTypeIn: UITextView!
    
    @IBOutlet weak var foodStep: UILabel!
    
    @IBOutlet weak var foodStepTypeIn: UITextView!
    
    @IBOutlet weak var updateButton: UIButton!
    
    var onPublished: (() -> Void)?
    
    var recipe: Recipe = Recipe(recipeID: "", recipeName: "", recipeImage: "", recipeFood: "", recipeStep: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()

    }
    
    private func setUI() {
        updateButton.addTarget(self, action: #selector(postToRecipeDB), for: .touchUpInside)
    }
    
    @objc func postToRecipeDB() {
        
        recipe.recipeName = recipeTextField.text!
        RecipeManager.shared.createRecipe(recipe: &recipe) { 
            result in
                switch result {
                case .success:
                    self.onPublished?()
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    
                    print("publishArticle.failure: \(error)")
                }
        }
        
    }
}
