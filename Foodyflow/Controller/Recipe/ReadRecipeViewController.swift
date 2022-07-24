//
//  ReadRecipeViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 7/7/22.
//

import UIKit

class ReadRecipeViewController: UIViewController {
    
    @IBOutlet weak var recipeImage: UIImageView!
    
    @IBOutlet weak var recipeName: UILabel!
    
    @IBOutlet weak var recipePersonName: UILabel!
    
    @IBOutlet weak var recipeNameTextField: UITextField!
    
    @IBOutlet weak var recipeFood: UILabel!
    
    @IBOutlet weak var recipeFoodTextView: UITextView!
    
    @IBOutlet weak var recipeStep: UILabel!
    
    @IBOutlet weak var recipeStepTextView: UITextView!
    
    var recipe: Recipe?
    
    var recipeNames: String = ""
    
    var recipeFoods: String = ""
    
    var recipeSteps: String = ""
    
    var recipeInImage: String = ""
    
    var recipeDoName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeNameTextField.text = recipeNames
        recipeNameTextField.isUserInteractionEnabled = false
        recipeFoodTextView.text = recipeFoods
        recipeFoodTextView.isEditable = false
        recipeStepTextView.text = recipeSteps
        recipeStepTextView.isEditable = false
        recipePersonName.text = "製作人\(recipeDoName)"
        if recipeInImage == "" {
            recipeImage.image = UIImage(named: "imageDefault") } else {
            recipeImage.kf.setImage( with: URL(string: recipeInImage )) }
        recipeImage.clipsToBounds = true
        recipeImage.contentMode = .scaleAspectFill
        
        setUPUI()
    }
    
    func setUPUI() {
        recipeImage.lkCornerRadius = 20
        recipeImage.isOpaque = true
        
        recipeName.text = "食譜名稱"
        recipeName.font = UIFont(name: "PingFang TC", size: 16)
        
        recipeNameTextField.layer.borderColor = UIColor.FoodyFlow.darkOrange.cgColor
        recipeNameTextField.layer.borderWidth = 0.3
        recipeNameTextField.backgroundColor = UIColor.FoodyFlow.extraOrange
        recipeNameTextField.lkCornerRadius = 10
        
        recipeFood.text = "所需食材"
        recipeFood.font = UIFont(name: "PingFang TC", size: 16)
        
        recipeStep.text = "食譜步驟"
        recipeStep.font = UIFont(name: "PingFang TC", size: 16)
        
        recipeFoodTextView.layer.borderColor = UIColor.FoodyFlow.darkOrange.cgColor
        recipeFoodTextView.layer.borderWidth = 0.3
        recipeFoodTextView.lkCornerRadius = 10
        recipeFoodTextView.backgroundColor = UIColor.FoodyFlow.extraOrange

        recipeStepTextView.layer.borderColor = UIColor.FoodyFlow.darkOrange.cgColor
        recipeStepTextView.layer.borderWidth = 0.3
        recipeStepTextView.lkCornerRadius = 10
        recipeStepTextView.backgroundColor = UIColor.FoodyFlow.extraOrange
    }
    
}
