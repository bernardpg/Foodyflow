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
    
    private lazy var allRecipeVC = AllRecipeViewController()
    
    private lazy var personalLikeVC = PersonalLikeREcipeViewController()
    
    private var viewPager =  LZViewPager()
    
    private lazy var containerView: [UIViewController] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "今天吃什麼"
        viewPagerProperties()
//        setUI()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           // navigationController?.navigationBar.prefersLargeTitles = true

           let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.FoodyFlow.darkOrange
        appearance.titleTextAttributes = [.foregroundColor: UIColor.FoodyFlow.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.FoodyFlow.white]
        appearance.shadowColor = .clear

        navigationController?.navigationBar.tintColor = UIColor.FoodyFlow.white
           navigationController?.navigationBar.standardAppearance = appearance
           navigationController?.navigationBar.compactAppearance = appearance
           navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
   }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //        FoodManager.shared.deleteFood(foodId: "22") { error11 in
 //           print("\(error11)")
//        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Main VC
    
    /*func viewPagerProperties() {
        view.addSubview(viewPager)
        
        viewPager.snp.makeConstraints { make in
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.top.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        viewPager.delegate = self
        viewPager.dataSource = self
        viewPager.hostController = self
        
     //   let allRecipeVC = UIStoryboard(name: "Main", bundle: nil)
       //     .instantiateViewController(withIdentifier: "allRecipeViewController")
       // as? AllRecipeViewController
        
       // let personalLikeVC = UIStoryboard(name: "Main", bundle: nil)
       //     .instantiateViewController(withIdentifier: "personalLikeREcipeViewController")
       // as? PersonalLikeREcipeViewController
        
      //  guard let allRecipeVC = allRecipeVC else { return }
     //   guard let personalLikeVC = personalLikeVC else { return }
        
        //allRecipeVC.title = "Recipe" allRecipeVC,
        personalLikeVC.title = "PresonalRecipe"
        
        containerView = [ personalLikeVC]
        viewPager.reload()
    }*/
    
    func viewPagerProperties() {
        view.addSubview(viewPager)
        
        viewPager.translatesAutoresizingMaskIntoConstraints = false
        viewPager.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        viewPager.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        viewPager.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        viewPager.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
 
        viewPager.delegate = self
        viewPager.dataSource = self
        viewPager.hostController = self
        
       // let wishListVC = UIStoryboard(name: "Main", bundle: nil).
        // instantiateViewController(withIdentifier: "wishListVC") as? WishListViewController
                
        let personalLikeREcipeViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "personalLikeREcipeViewController")
            as? PersonalLikeREcipeViewController
        
        // guard let wishListVC = wishListVC else { return }
        guard let personalLikeREcipeViewController = personalLikeREcipeViewController else { return }

        allRecipeVC.title = "食譜"
        personalLikeREcipeViewController.title = "私藏菜單"
        
        containerView = [allRecipeVC, personalLikeREcipeViewController]
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
        button.titleLabel?.font = UIFont(name: "PingFang TC", size: 16)
        button.setTitleColor(.FoodyFlow.lightGray, for: .normal)
        button.setTitleColor(.FoodyFlow.black, for: .selected)
        button.backgroundColor = UIColor.FoodyFlow.white
        return button
    }
    
    func backgroundColorForHeader() -> UIColor {
        
        return UIColor.FoodyFlow.lightOrange
    }
    
    func colorForIndicator(at index: Int) -> UIColor {
        
        return UIColor.FoodyFlow.darkOrange
    }
    
}
