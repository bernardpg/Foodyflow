//
//  RefrigeProductDetailViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/16/22.
//

import UIKit
import Photos
import Firebase
import FirebaseStorage
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class RefrigeProductDetailViewController: UIViewController {
        
    var completion: CompletionHandler?
    
    var selectedImage: UIImage?
    
    var onPublished: (()->())?
    @IBOutlet weak var imageUpload: UIButton!
    
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
    
    var refrige: Refrige = Refrige(
        id: "2", // id need to fetch
        title: "我得冰箱",
        foodID: [""], // foodID is too
        createdTime: -1,
        category: "",
        shoppingList: []
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodName.text = "食物名稱"
        foodCate.text = "食物種類"
        purchaseDate.text = "購買日期"
        expireDate.text = "過期日期"
        
        self.foodNameTextField.text = foodItemName
        
        imageUpload.addTarget(self, action: #selector(selectPhoto), for: .touchUpInside)
        updateButton.addTarget(self, action: #selector(finishUpdate), for: .touchUpInside)
        }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false        
    }
    
    func setFoodName(with name: String) {
        foodItemName = name
    }
    @objc func finishUpdate() {
        
        foodInfo.foodName = foodNameTextField.text
        foodInfo.foodCategory = "雞肉"
        foodInfo.foodStatus = 3
//        foodInfo.foodCategory = "\(foodWeightAmount.text)"
//        foodInfo.purchaseDate = "\(Int64(purchaseDateTextfield.text))"
//        foodInfo.expireDate =
        FoodManager.shared.publishFood(food: &foodInfo) { result in
            switch result {

            case .success:
                print("onTapPublish, success")
                
                self.onPublished?()
                self.uploadPhoto()
            case .failure(let error):
                
                print("publishArticle.failure: \(error)")
            }
        }
        guard let foodId = foodId else { return }  // bugs
        refrige.foodID.append(foodId)
        RefrigeManager.shared.publishFoodOnRefrige(refrige: &self.refrige) { result in
            
            self.onPublished?()
            
        }

        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func selectPhoto(recognizer:UITapGestureRecognizer) {
        if  recognizer.state == .began{
            action()
        }

    }
    func action(){
            
            let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "open camera", style: .default, handler: { (handler) in
                self.openCamera()
            }))
            
            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (handler) in
                self.openGallery()
                
            }))
            
            alert.addAction(UIAlertAction(title: "cancel", style: .default, handler: { (handler) in
                
            }))
            
            self.present(alert, animated: true)
            
        }
    
    func openCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self // camera part
        present(picker, animated: true) {
        }

    }
    
    func openGallery() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    func uploadPhoto() {
            
            guard selectedImage != nil else { return }
            
            let imageData =  selectedImage?.jpegData(compressionQuality: 0.8)
            
            guard let imageData = imageData else { return }
    //        Storage.storage().reference()
            let storageRef =         FirebaseStorage.Storage.storage().reference()

            // file Name
            
            let path = "images/\(UUID().uuidString).jpg"
            let fileRef = storageRef.child(path)
            
            // upload that data
            let uploadTask = fileRef.putData(imageData, metadata: nil) { metadata, error in
                if error == nil && metadata != nil {
                    
                    let db = Firestore.firestore()
                
                    db.collection("foods").document(foodId!).updateData(["foodImages":path])
                }
                
            }
                     
        }
}

extension RefrigeProductDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        foodImage?.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        selectedImage = foodImage?.image

        picker.dismiss(animated: true) {
        }
    }
}
