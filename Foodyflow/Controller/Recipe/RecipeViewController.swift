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
    
    @IBOutlet weak var buttomLineView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()

        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        recipeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(recipeView)
        recipeView.backgroundColor = .black
        recipeView.topAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: 0).isActive = true
        recipeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        recipeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        recipeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        collectionRecipeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionRecipeView)
        collectionRecipeView.backgroundColor = UIColor.B2
        collectionRecipeView.topAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: 0).isActive = true
        collectionRecipeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        collectionRecipeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionRecipeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
    }
    
    // container View didset
    
    
}
