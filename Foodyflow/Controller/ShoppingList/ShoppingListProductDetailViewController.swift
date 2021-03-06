//
//  ShoppingListProductDetailViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/20/22.
//

import UIKit
import FirebaseStorage

class ShoppingListProductDetailViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var foodCateName: UILabel!
    
    @IBOutlet weak var foodImage: UIImageView!
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
    @IBOutlet weak var selectPhoto: UIButton!
    
    @IBOutlet weak var catePick: UIButton!
    
    @IBOutlet weak var catePicker: UIPickerView!
    let imagePickerController = UIImagePickerController()
    
    var photoManager = PhotoManager()
    
    var onPublished: (() -> Void)?
    
    var foodInfo = FoodInfo()
    
    var shoppingList: ShoppingList = ShoppingList( id: "", title: "", foodID: [""] )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        selectPhoto.addTarget(self, action: #selector(changePhoto), for: .touchUpInside)
        updateButton.addTarget(self, action: #selector(postToRefirgeDB), for: .touchUpInside)
        catePicker.isHidden = true
        
        imagePickerController.delegate = self

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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        foodImage.clipsToBounds = true
        foodImage.contentMode = .scaleAspectFill
        foodImage.lkCornerRadius = 20
    }
    
    func setUI() {
        foodCateName.text = "分類"
//        foodCateTextField.lkCornerRadius = 20
//        foodCateTextField.layer.borderColor = UIColor.FoodyFlow.lightOrange.cgColor
//        foodCateTextField.backgroundColor = UIColor.FoodyFlow.extraOrange
//        foodCateTextField.text = foodInfo.foodCategory
        foodName.text = "食材名稱"
        foodNameTextField.lkCornerRadius = 20
        foodNameTextField.backgroundColor = UIColor.FoodyFlow.extraOrange
        foodNameTextField.layer.borderColor = UIColor.FoodyFlow.lightOrange.cgColor
        
        foodNameTextField.text = foodInfo.foodName

        foodBrand.text = "品牌"
        foodBrandTextField.lkCornerRadius = 20
        foodBrandTextField.backgroundColor = UIColor.FoodyFlow.extraOrange
        foodBrandTextField.layer.borderColor = UIColor.FoodyFlow.lightOrange.cgColor
        
        foodBrandTextField.text = foodInfo.foodBrand

        foodWeightTextField.lkCornerRadius = 20
        foodWeightTextField.backgroundColor = UIColor.FoodyFlow.extraOrange
        foodWeightTextField.layer.borderColor = UIColor.FoodyFlow.lightOrange.cgColor
        foodWeightTextField.keyboardType = UIKeyboardType.numberPad
        foodWeightTextField.text = foodInfo.foodBrand

        foodBuy.text = "購買地點"
        foodBuyPlaceTextfield.lkCornerRadius = 20
        foodBuyPlaceTextfield.backgroundColor = UIColor.FoodyFlow.extraOrange
        foodBuyPlaceTextfield.layer.borderColor = UIColor.FoodyFlow.lightOrange.cgColor
        
        foodBuyPlaceTextfield.text = foodInfo.foodPurchasePlace

        foodAddidtional.text = "備註"
        
        foodAdditionalTextVIew.lkCornerRadius = 10
        foodAdditionalTextVIew.backgroundColor = UIColor.FoodyFlow.extraOrange
        foodAdditionalTextVIew.layer.borderColor = UIColor.FoodyFlow.lightOrange.cgColor
        
        foodAdditionalTextVIew.text = foodInfo.additional
        
        updateButton.lkCornerRadius = 10
        updateButton.tintColor = UIColor.FoodyFlow.white
        updateButton.backgroundColor = UIColor.FoodyFlow.darkOrange
        if foodInfo.foodImages == "" {
            foodImage.image = UIImage(named: "imageDefault") } else if foodInfo.foodImages == nil {foodImage.image = UIImage(named: "imageDefault")} else {
            foodImage.kf.setImage( with: URL(string: foodInfo.foodImages ))
        }
        catePick.titleLabel?.font = UIFont(name: "PingFang TC", size: 20)
        if #available(iOS 15.0, *) {
            catePick.setTitle(foodInfo.foodCategory, for: .selected)

            catePick.setTitle(foodInfo.foodCategory, for: .application)
            
//            catePick.showsMenuAsPrimaryAction = true

//            catePick.changesSelectionAsPrimaryAction = true
            catePick.menu = createSiteMenu(actionTitle: foodInfo.foodCategory)
        } else {
            // Fallback on earlier versions
        }

    }
    
     func createSiteMenu(actionTitle: String? = nil) -> UIMenu {
        let siteMenuItems =  [
            UIAction(title: "肉類", handler: { _ in
                self.foodInfo.foodCategory = "肉類"
            }),
            UIAction(title: "豆類", handler: { _ in
                self.foodInfo.foodCategory = "豆類"
            }),
            UIAction(title: "雞蛋類", handler: { _ in
                self.foodInfo.foodCategory = "雞蛋類"
            }),
            UIAction(title: "青菜類", handler: { _ in
                self.foodInfo.foodCategory = "青菜類"
            }),
            UIAction(title: "醃製類", handler: { _ in
                self.foodInfo.foodCategory = "醃製類"
            }),
            UIAction(title: "水果類", handler: { _ in
                self.foodInfo.foodCategory = "水果類"
            }),
            UIAction(title: "魚類", handler: { _ in
                self.foodInfo.foodCategory = "魚類"
            }),
            UIAction(title: "海鮮類", handler: { _ in
                self.foodInfo.foodCategory = "海鮮類"
            }),
            UIAction(title: "飲料類", handler: { _  in
                self.foodInfo.foodCategory = "飲料類"
            }),
            UIAction(title: "調味料類", handler: { _ in
                self.foodInfo.foodCategory = "調味料類"
            }),
            UIAction(title: "其他類", handler: { _ in
                self.foodInfo.foodCategory = "其他類"
            })
        ]
        let menu = UIMenu(title: "請選擇種類", image: nil, identifier: nil, options: [], children: siteMenuItems)
        catePick?.menu = updateActionState(actionTitle: actionTitle, menu: menu)
        catePick?.showsMenuAsPrimaryAction = true
        return menu
    }
    
     func updateActionState(actionTitle: String? = nil, menu: UIMenu) -> UIMenu {
        if let actionTitle = actionTitle {
            menu.children.forEach { action in
                guard let action = action as? UIAction else {
                    return
                }
                if action.title == actionTitle {
                    action.state = .on
                }
            }
        } else {
            let action = menu.children.first as? UIAction
            action?.state = .on
        }
        return menu
    }
    
    func postFoodOnShoppingList() {
        
    }
    
    func updateFoodOnshoppingList() {
        
    }
    
    @objc func changePhoto() {
        photoManager.tapPhoto(controller: self, alertText: "選擇清單照片", imagePickerController: imagePickerController)
    }
    
    @objc func postToRefirgeDB() {
        
        guard let foodImage = foodImage.image else {
            return }
        uploadPhoto(image: foodImage) { [self] result in
            switch result {
            case .success(let url):
                
                foodInfo.foodName = foodNameTextField.text
//                foodInfo.foodCategory = foodCateTextField.text
                foodInfo.foodWeightAmount = Double(foodWeightTextField.text ?? "")
                foodInfo.foodBrand = foodBrandTextField.text
                foodInfo.foodPurchasePlace = foodBuyPlaceTextfield.text
                foodInfo.foodStatus = 1
                foodInfo.foodImages = "\(url)"
                
                FoodManager.shared.publishFood( food: &foodInfo ) { result in
                    switch result {

                    case .success:
                        print("onTapPublish, success")
                        
                        self.onPublished?()
                    case .failure(let error):
                        
                        print("publishArticle.failure: \(error)")
                    }
                }
                shoppingListNowID = shoppingList.id
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
                self.navigationController?.popViewController(animated: true)
            case .failure:
                print("UploadPhoto Error")
            }
            }
        }

    @objc func postUpdate() {
        
        foodInfo.foodName = foodNameTextField.text
//        foodInfo.foodCategory = foodCateTextField.text
        foodInfo.foodWeightAmount = Double(foodWeightTextField.text ?? "")
        foodInfo.foodBrand = foodBrandTextField.text
        foodInfo.foodPurchasePlace = foodBuyPlaceTextfield.text
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
    
    func uploadPhoto(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
            
            let fileReference = Storage.storage().reference().child(UUID().uuidString + ".jpg")
            if let data = image.jpegData(compressionQuality: 0.6) {
                
                fileReference.putData(data, metadata: nil) { result in
                    switch result {
                    case .success:
                        fileReference.downloadURL { result in
                            switch result {
                            case .success(let url):
                                self.foodInfo.foodImages = "\(url)"
                                completion(.success(url))
                            case .failure(let error):
                                completion(.failure(error))

                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
    }

}
extension ShoppingListProductDetailViewController: UITextViewDelegate {
   
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {

            textView.text = "請輸入"
            textView.textColor = UIColor.lightGray

            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument,
                                                            to: textView.beginningOfDocument)
        }

        // Else if the text view's placeholder is showing and the
        // length of the replacement string is greater than 0, set
        // the text color to black then set its text to the
        // replacement string
         else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        }

        // For every other case, the text should change with the usual
        // behavior...
        else {
            return true
        }
        // ...otherwise return false since the updates have already
        // been made
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument,
                                                                to: textView.beginningOfDocument)
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView, _ placeholderLabel: UILabel) {
            placeholderLabel.isHidden = !textView.text.isEmpty
        }
}

extension ShoppingListProductDetailViewController: UIImagePickerControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            foodImage.image = image
        }
        
        picker.dismiss(animated: true)
    }
}
