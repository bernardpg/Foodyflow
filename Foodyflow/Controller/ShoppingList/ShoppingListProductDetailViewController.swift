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
        
        setUI()
        updateButton.addTarget(self, action: #selector(postUpdate), for: .touchUpInside)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func setUI() {
        foodCateName.text = "分類"
        foodCateTextField.lkCornerRadius = 20
        foodCateTextField.layer.borderColor = UIColor.FoodyFlow.lightOrange.cgColor
        foodCateTextField.backgroundColor = UIColor.FoodyFlow.extraOrange
        foodName.text = "食材名稱"
        foodNameTextField.lkCornerRadius = 20
        foodNameTextField.backgroundColor = UIColor.FoodyFlow.extraOrange
        foodNameTextField.layer.borderColor = UIColor.FoodyFlow.lightOrange.cgColor

        foodBrand.text = "品牌"
        foodBrandTextField.lkCornerRadius = 20
        foodBrandTextField.backgroundColor = UIColor.FoodyFlow.extraOrange
        foodBrandTextField.layer.borderColor = UIColor.FoodyFlow.lightOrange.cgColor
        
        foodWeightTextField.lkCornerRadius = 20
        foodWeightTextField.backgroundColor = UIColor.FoodyFlow.extraOrange
        foodWeightTextField.layer.borderColor = UIColor.FoodyFlow.lightOrange.cgColor

        foodBuy.text = "購買地點"
        foodBuyPlaceTextfield.lkCornerRadius = 20
        foodBuyPlaceTextfield.backgroundColor = UIColor.FoodyFlow.extraOrange
        foodBuyPlaceTextfield.layer.borderColor = UIColor.FoodyFlow.lightOrange.cgColor

        foodAddidtional.text = "購買地點"
        
        foodAdditionalTextVIew.lkCornerRadius = 10
        foodAdditionalTextVIew.backgroundColor = UIColor.FoodyFlow.extraOrange
        foodAdditionalTextVIew.layer.borderColor = UIColor.FoodyFlow.lightOrange.cgColor
        
        updateButton.lkCornerRadius = 10
        updateButton.tintColor = UIColor.FoodyFlow.white
        updateButton.backgroundColor = UIColor.FoodyFlow.darkOrange

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
            switch result {
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
