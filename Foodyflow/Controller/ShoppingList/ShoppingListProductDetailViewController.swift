//
//  ShoppingListProductDetailViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/20/22.
//

import UIKit

class ShoppingListProductDetailViewController: UIViewController {

    @IBOutlet weak var foodCateName: UILabel!
    
    @IBOutlet weak var foodCateTextField: UITextField!
    
    @IBOutlet weak var foodName: UILabel!
    
    @IBOutlet weak var foodNameTextField: UITextField!
    
    @IBOutlet weak var foodWeightTextField: UITextField!
    
    @IBOutlet weak var foodBrand: UILabel!
    
    @IBOutlet weak var foodBrandTextField: UITextField!
    
    @IBOutlet weak var foodBuy: UILabel!
    
    @IBOutlet weak var foodBuyPlaceTextfield: UITextField!
    
    @IBOutlet weak var foodAddidtional: UILabel!
    
    @IBOutlet weak var foodAdditionalTextVIew: UITextView!
    
    @IBOutlet weak var updateButton: UIButton!
    
    var onPublished: (() -> Void)?
    
    var foodInfo = FoodInfo()
    
    var shoppingList: ShoppingList = ShoppingList(
        foodID: [""]
)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButton.addTarget(self, action: #selector(postUpdate), for: .touchUpInside)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func postFoodOnShoppingList() {
        
    }
    
    func updateFoodOnshoppingList() {
        
    }
    
    @objc func postUpdate() {
        
        foodInfo.foodName = foodNameTextField.text
        foodInfo.foodCategory = "水果類"
        foodInfo.foodStatus = 1
        
        FoodManager.shared.publishFood(food: &foodInfo) { result in
            switch result {

            case .success:
                print("onTapPublish, success")
                
                self.onPublished?()
 //               self.uploadPhoto()
            case .failure(let error):
                
                print("publishArticle.failure: \(error)")
            }
        }
        shoppingListNowID = "dwdwdwd" // fetch initial
        guard let foodId = foodId else { return }  // bugs
        shoppingList.foodID.append(foodId)
        ShoppingListManager.shared.postFoodOnShoppingList(shoppingList: &shoppingList) { result in
            switch result{
            case .success:
                self.onPublished?()
            case .failure(let error):
                
                print("publishArticle.failure: \(error)")
            }
            
        }
//        refrige.foodID.append(foodId)
//        RefrigeManager.shared.publishFoodOnRefrige(refrige: &self.refrige) { result in
            
//            self.onPublished?()
            
//        }
        self.navigationController?.popViewController(animated: true)
    }
    
}
