//
//  RecipeViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/20/22.
//

import UIKit
import LZViewPager

class RecipeViewController: UIViewController, LZViewPagerDelegate, LZViewPagerDataSource {
    
    private var recipeView = UIView()
    private var collectionRecipeView = UIView()
    
    private var viewPager =  LZViewPager()
        
    private lazy var containerView: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPagerProperties()
//        setUI()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        FoodManager.shared.deleteFood(foodId: "22") { error11 in
 //           print("\(error11)")
//        }
        
    }
    
    // MARK: - Main VC
    func viewPagerProperties() {
        view.addSubview(viewPager)
        
        viewPager.translatesAutoresizingMaskIntoConstraints = false
        viewPager.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
            constant: 0).isActive = true
        viewPager.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
            constant: 0).isActive = true
        viewPager.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        viewPager.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: 0).isActive = true
        
        viewPager.delegate = self
        viewPager.dataSource = self
        viewPager.hostController = self
        
        let allRecipeVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "allRecipeViewController")
        as? AllRecipeViewController
        
        let personalLikeVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "personalLikeREcipeViewController")
        as? PersonalLikeREcipeViewController
        
        guard let allRecipeVC = allRecipeVC else { return }
        guard let personalLikeVC = personalLikeVC else { return }
        
        allRecipeVC.title = "Recipe"
        personalLikeVC.title = "PresonalRecipe"
        
        containerView = [allRecipeVC,personalLikeVC]
        viewPager.reload()
    }
    
    func numberOfItems() -> Int {
        containerView.count
    }
    
    func controller(at index: Int) -> UIViewController {
        containerView[index]
    }
    
    func button(at index: Int) -> UIButton {
        let button = UIButton()
        button.setTitleColor(UIColor.B1, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.backgroundColor = .black
        return button
    }
    
    func setUI() {
        recipeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(recipeView)
//        recipeView.backgroundColor = .black
        recipeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        recipeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        recipeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        recipeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        collectionRecipeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionRecipeView)
        collectionRecipeView.backgroundColor = UIColor.B2
        collectionRecipeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        collectionRecipeView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: 0).isActive = true
        collectionRecipeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionRecipeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    }

}
