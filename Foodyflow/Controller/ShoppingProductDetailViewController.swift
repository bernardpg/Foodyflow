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
    
    @IBOutlet weak var foodNameTextField: UITextField!
    
    var foodName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        
        self.foodNameTextField.text = foodName
        
//        guard let name = foodName.text else { return }
//        let dict = ["name": name]
//        guard let completion = completion else {
//            return
//        }
//        completion(dict)
    }
    
    func setFoodName(with name: String) {
        foodName = name
    }
    
}
