//
//  RecipeViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/20/22.
//

import UIKit

class RecipeViewController: UIViewController {
    
    private var recipeView = UIView()
    private var collectionRecipeView = UIView()

    @IBOutlet weak var indicatorView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()

        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        
        view.addSubview(recipeView)
        recipeView.translatesAutoresizingMaskIntoConstraints = false
        recipeView.topAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: 0).isActive = true
        recipeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        recipeView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        recipeView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        
        view.addSubview(collectionRecipeView)
        collectionRecipeView.translatesAutoresizingMaskIntoConstraints = false
        collectionRecipeView.topAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: 0).isActive = true
        collectionRecipeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        collectionRecipeView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        collectionRecipeView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true

        
    }
    
}
