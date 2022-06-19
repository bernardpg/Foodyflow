//
//  ShoppingProductDetailViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/16/22.
//

import UIKit

class ShoppingProductDetailViewController: UIViewController {
    
    typealias CompletionHandler = ([ String : Any ]) -> Void
    
    var completion: CompletionHandler?
    
    var onPublished: (()->())?
    
    @IBOutlet weak var foodNameTextField: UITextField!
    
    @IBOutlet weak var foodNameCateTextField: UITextField!
    @IBOutlet weak var foodName: UILabel!
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodCate: UILabel!
    
    @IBOutlet weak var foodWeightAmount: UITextField!
    
    @IBOutlet weak var foodWeighType: UIPickerView!
    @IBOutlet weak var purchaseDate: UILabel!
    @IBOutlet weak var purchaseDateTextfield: UITextField!
    
    @IBOutlet weak var expireDate: UILabel!
    
    @IBOutlet weak var expireDateTextfield: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    
    var foodItemName: String?
    var foodCateType = ["肉類", "海鮮", "蛋類", "菜類", "其他"]
    
    var foodInfo: FoodInfo = FoodInfo(
        foodId: "",
        foodName: "",
        foodStatus: -1,
        createdTime: -1
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodName.text = "食物名稱"
        foodCate.text = "食物種類"
        purchaseDate.text = "購買日期"
        expireDate.text = "過期日期"
        
        self.foodNameTextField.text = foodItemName
        
//        guard let name = foodName.text else { return }
//        let dict = ["name": name]
//        guard let completion = completion else {
//            return
//        }
//        completion(dict)
        updateButton.addTarget(self, action: #selector(finishUpdate), for: .touchUpInside)
    }
    
    func setFoodName(with name: String) {
        foodItemName = name
    }
    
    @objc func finishUpdate() {
        
        foodInfo.foodName = foodNameTextField.text
        foodInfo.foodStatus = 3
//        foodInfo.foodCategory = "\(foodWeightAmount.text)"
//        foodInfo.purchaseDate = "\(Int64(purchaseDateTextfield.text))"
//        foodInfo.expireDate =
        FoodManager.shared.publishFood(food: &foodInfo) { result in
            switch result {

            case .success:
                
                print("onTapPublish, success")
                self.onPublished?()
                
            case .failure(let error):
                
                print("publishArticle.failure: \(error)")
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
}
