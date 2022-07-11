//
//  AddRecipeViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/27/22.
//

import UIKit
import FirebaseStorage
import AVFoundation

class AddRecipeViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var recipeImage: UIImageView!
    
    @IBOutlet weak var foodNeeded: UILabel!
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    
    @IBOutlet weak var recipeTextField: UITextField!
    
    @IBOutlet weak var foodTypeIn: UITextView!
    
    @IBOutlet weak var foodStep: UILabel!
    
    @IBOutlet weak var foodStepTypeIn: UITextView!
    
    @IBOutlet weak var updateButton: UIButton!
    
    @IBOutlet weak var changeRecipePic: UIButton!
    
    let imagePickerController = UIImagePickerController()
    
    var photoManager = PhotoManager()
    
    var onPublished: (() -> Void)?
    
    var placeholderLabel = UILabel()
    
    var recipeholderLabel = UILabel()
    
    var recipe: Recipe?
    // = Recipe(recipeID: "", recipeName: "", recipeImage: "", recipeFood: "", recipeStep: "")
    
    var recipeName: String = ""
    
    var recipeFood: String = ""
    
    var recipeStep: String = ""
    
    var recipeInImage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeTextField.text = recipeName
        
        foodTypeIn.text = recipeFood
        foodStepTypeIn.text = recipeStep
        
        if recipeInImage == "" {
                recipeImage.image = UIImage(named: "imageDefault") } else{
            recipeImage.kf.setImage( with: URL(string: recipeInImage ))
        }
        
//        recipeImage.image = recipeInImage
        
        setUI()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        changeRecipePic.lkCornerRadius = changeRecipePic.frame.height / 2
    }
    
    private func setUI() {
        
        imagePickerController.delegate = self
        
        // changeRecipePic.backgroundColor = UIColor.FoodyFlow.lightOrange
        recipeImage.lkCornerRadius = 20
        // changeRecipePic.layer.backgroundColor = UIColor.FoodyFlow.darkOrange.cgColor
        // changeRecipePic.imageView?.tintColor = UIColor.FoodyFlow.white
        changeRecipePic.addTarget(self, action: #selector(changeRecipeImage), for: .touchUpInside)
        recipeImage.isOpaque = true
        recipeNameLabel.text = "食譜名稱"
        recipeNameLabel.font = UIFont(name: "PingFang TC", size: 16)
        recipeTextField.layer.borderColor = UIColor.FoodyFlow.darkOrange.cgColor
        recipeTextField.layer.borderWidth = 0.3
        recipeTextField.backgroundColor = UIColor.FoodyFlow.extraOrange
        recipeTextField.lkCornerRadius = 10
        foodNeeded.text = "所需食材"
        foodNeeded.font = UIFont(name: "PingFang TC", size: 16)
        
        foodStep.text = "食譜步驟"
        foodStep.font = UIFont(name: "PingFang TC", size: 16)
        setTextView( label: &placeholderLabel, text: "請輸入食材", inputTextVIew: foodTypeIn)
        foodTypeIn.layer.borderColor = UIColor.FoodyFlow.darkOrange.cgColor
        foodTypeIn.layer.borderWidth = 0.3
        foodTypeIn.lkCornerRadius = 10

        foodTypeIn.backgroundColor = UIColor.FoodyFlow.extraOrange

        foodStepTypeIn.layer.borderColor = UIColor.FoodyFlow.darkOrange.cgColor
        foodStepTypeIn.layer.borderWidth = 0.3
        foodStepTypeIn.lkCornerRadius = 10
        foodStepTypeIn.backgroundColor = UIColor.FoodyFlow.extraOrange

        setTextView( label: &recipeholderLabel, text: "請輸入食譜步驟", inputTextVIew: foodStepTypeIn)
        
        updateButton.setTitle("發布食譜", for: .normal)
        updateButton.lkCornerRadius = 10
        updateButton.backgroundColor = UIColor.FoodyFlow.darkOrange
        updateButton.tintColor = UIColor.FoodyFlow.white
        updateButton.addTarget(self, action: #selector(postToRecipeDB), for: .touchUpInside)
    }
    
    private func setTextView(label: inout UILabel, text: String, inputTextVIew: UITextView) {
        
        inputTextVIew.textColor = UIColor.FoodyFlow.black

        inputTextVIew.delegate = self
        // label = UILabel()
        // label.text = "\(text)"
        // label.font = .italicSystemFont(ofSize: (inputTextVIew.font?.pointSize)!)
        // label.sizeToFit()
        // inputTextVIew.addSubview(label)
        // label.frame.origin = CGPoint(x: 5, y: (inputTextVIew.font?.pointSize)! / 2)
        // label.textColor = .tertiaryLabel
        textViewDidChange(inputTextVIew, label)
        label.isHidden = !inputTextVIew.text.isEmpty

    }
    
    @objc func changeRecipeImage() {
        photoManager.tapPhoto(controller: self, alertText: "選擇食譜照片", imagePickerController: imagePickerController)
        
    }
    @objc func postToRecipeDB() {
    //    let url = URL(string: ("\(recipe?.recipeImage)"))
    //    guard let url = url else {
     //       return
     //   }
      //  let recipeURL =  String(contentsOf: url)
        guard let recipeImage = recipeImage.image else {
            return
        }
        uploadPhoto(image: recipeImage) { [self] result in
            switch result {
            case .success(let url):
                var recipe = Recipe(recipeID: "",
                                    recipeName: recipeTextField.text!,
                                    recipeImage: "\(url)",
                                    recipeFood: foodTypeIn.text,
                                    recipeStep: foodStepTypeIn.text)
        //        recipe.recipeName = recipeTextField.text!
        //        recipe.recipeFood = foodTypeIn.text
        //        recipe.recipeStep = foodStepTypeIn.text
                RecipeManager.shared.createRecipe(recipe: &recipe) {
                    result in
                        switch result {
                        case .success:
                            self.onPublished?()
                            self.navigationController?.popViewController(animated: true)
                        case .failure(let error):
                            
                            print("publishArticle.failure: \(error)")
                        }
                }
                
            case .failure(_):
                print("UploadPhoto Error")
            }
        }
    }
    
    func uploadPhoto(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {

//        let imageData = self.userImage.image?.jpegData(compressionQuality: 0.8)
        
//        guard imageData != nil else {
//            return
//        }
            
            let fileReference = Storage.storage().reference().child(UUID().uuidString + ".jpg")
            if let data = image.jpegData(compressionQuality: 0.6) {
                
                fileReference.putData(data, metadata: nil) { result in
                    switch result {
                    case .success:
                        fileReference.downloadURL { result in
                            switch result {
                            case .success(let url):
                                self.recipe?.recipeImage = "\(url)"
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

extension AddRecipeViewController : UITextViewDelegate {
   
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {

            textView.text = "請輸入"
            textView.textColor = UIColor.lightGray

            textView.selectedTextRange = textView.textRange(
                from: textView.beginningOfDocument,
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
                textView.selectedTextRange = textView.textRange(
                    from: textView.beginningOfDocument,
                    to: textView.beginningOfDocument)
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView, _ placeholderLabel: UILabel) {
            placeholderLabel.isHidden = !textView.text.isEmpty
        }
}

extension AddRecipeViewController: UIImagePickerControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.recipeImage.image = image
        }
        
        picker.dismiss(animated: true)
    }
}
