//
//  PhotoManager.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 7/3/22.
//

import UIKit

struct PhotoManager {
    
    func tapPhoto(controller: UIViewController, alertText: String, imagePickerController: UIImagePickerController) {
        
//        let imagePickerController = UIImagePickerController()

        let alertController = UIAlertController(title: alertText, message: "", preferredStyle: .alert)
        alertController.view.tintColor = UIColor.gray
        
        // Camera
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            takePicture()
        }
        alertController.addAction(cameraAction)
        
        // Photo
        let photoLibraryAction = UIAlertAction(title: "Gallery", style: .default) { _ in
            openPhotoLibrary()
        }
        alertController.addAction(photoLibraryAction)
        
        // Gallery
        let savedPhotoAlbumAction = UIAlertAction(title: "Album", style: .default) { _ in
            openPhotosAlbum()
        }
        alertController.addAction(savedPhotoAlbumAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        
        controller.present(alertController, animated: true, completion: nil)
        
        func takePicture() {
            imagePickerController.sourceType = .camera
            controller.present(imagePickerController, animated: true)
        }
        
        // turn on libary
        func openPhotoLibrary() {
            imagePickerController.sourceType = .photoLibrary
            controller.present(imagePickerController, animated: true)
        }
        
        // turn on album
        func openPhotosAlbum() {
            imagePickerController.sourceType = .savedPhotosAlbum
            controller.present(imagePickerController, animated: true)
        }
    }
    
}
