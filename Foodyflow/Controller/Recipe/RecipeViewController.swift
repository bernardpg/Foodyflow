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

    @IBOutlet weak var indicatorView: UIView!
    
    @IBOutlet weak var buttomLineView: UIView!
    
    private var viewPager =  LZViewPager()
    
    private lazy var recipeVC = AllRecipeViewController()
    
    private lazy var personalRecipeVC = PersonalLikeREcipeViewController()
    
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
        

        
//        let wishListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wishListVC") as? WishListViewController
                
//        let inshoppingListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inshoppingListVC") as? InshoppingViewController
        
 //       guard let wishListVC = wishListVC else { return }
 //       guard let inshoppingListVC = inshoppingListVC else { return }
        
        

        recipeVC.title = "Recipe"
        personalRecipeVC.title = "PresonalRecipe"
        
        containerView = [recipeVC,personalRecipeVC]
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
        recipeView.topAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: 0).isActive = true
        recipeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        recipeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        recipeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        collectionRecipeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionRecipeView)
        collectionRecipeView.backgroundColor = UIColor.B2
        collectionRecipeView.topAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: 0).isActive = true
        collectionRecipeView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: 0).isActive = true
        collectionRecipeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionRecipeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    }

}
