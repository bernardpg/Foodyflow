//
//  PersonalViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/20/22.
//

import UIKit

class PersonalViewController: UIViewController {

    @IBOutlet weak var addRefrigeButton: UIButton!
    @IBOutlet weak var personalSettingButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRefrigeButton.addTarget(self, action: #selector(addRefri), for: .touchUpInside)
        
        personalSettingButton.addTarget(self, action: #selector(personalSetting), for: .touchUpInside)

    }
    
    @objc func addRefri() {
        
        tapPhoto(controller: self, mainTitle: "請選擇", firstTitle: "創建新食光", secondTitle: "邀請加入xxx食光", cancelTitle: "取消")
    }
    
    @objc func personalSetting() {
        tapPhoto(controller: self, mainTitle: "更換個人設定", firstTitle: "更換照片", secondTitle: "更換暱稱", cancelTitle: "取消")
    }
    
    func tapPhoto(controller: UIViewController,mainTitle: String, firstTitle:String, secondTitle: String, cancelTitle: String) {
        
        let alertController = UIAlertController(title: "\(mainTitle)", message: "", preferredStyle: .alert)
        alertController.view.tintColor = UIColor.gray
        
        // Camera
        let cameraAction = UIAlertAction(title: "\(firstTitle)", style: .default) { _ in
            //self.takePicture()
        }
        alertController.addAction(cameraAction)
        
        // Photo
        let photoLibraryAction = UIAlertAction(title: "\(secondTitle)", style: .default) { _ in
            //self.openPhotoLibrary()
        }
        alertController.addAction(photoLibraryAction)
        
        let cancelAction = UIAlertAction(title: "\(cancelTitle)", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        
        controller.present(alertController, animated: true, completion: nil)
    }

}
