//
//  CreatePersonViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/28/22.
//

import UIKit
import SnapKit
import FirebaseAuth

class CreatePersonViewController: UIViewController {
    
    private lazy var createUser = UIButton()
    private lazy var inviteUser = UIButton()
    private lazy var appOutsideIcon = UIView()
    private lazy var appIcon = UIImageView()
    private let background = UIImageView()
    
    
    var refrige = Refrige.init(id: "", title: "我的冰箱", foodID: [], createdTime: 0, category: "", shoppingList: [])

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(imageTapped(tapGestureRecognizer:)))
        background.isUserInteractionEnabled = true
        background.addGestureRecognizer(tapGestureRecognizer)

    }
    
    private func setUI() {
        view.addSubview(background)
        background.snp.makeConstraints { make in
            make.trailing.equalTo(view)
            make.leading.equalTo(view)
            make.top.equalTo(view)
            make.bottom.equalTo(view)
        }
        background.isUserInteractionEnabled = true

        background.image = UIImage(named: "memberlog")
        
        background.addSubview(createUser)
        createUser.snp.makeConstraints { make in
            make.centerX.equalTo(background.snp.centerX)
            make.centerY.equalTo(background.snp.centerY).offset(290)
            make.width.equalTo(163)
            make.height.equalTo(45)
        }
        createUser.layer.borderColor = UIColor.FoodyFlow.darkOrange.cgColor
        createUser.layer.borderWidth = 0.3
        createUser.setTitle("建立食光", for: .normal)
        createUser.setTitleColor(UIColor.FoodyFlow.darkOrange, for: .normal)
        createUser.backgroundColor = UIColor.FoodyFlow.white
        createUser.addTarget(self, action: #selector(createRefrig), for: .touchUpInside)
        
        background.addSubview(inviteUser)
        inviteUser.snp.makeConstraints { make in
            make.centerX.equalTo(createUser.snp.centerX)
            make.centerY.equalTo(createUser.snp.centerY).offset(60)
            make.width.equalTo(163)
            make.height.equalTo(45)
        }
        
        inviteUser.layer.borderColor = UIColor.FoodyFlow.darkOrange.cgColor
        inviteUser.layer.borderWidth = 0.3
        inviteUser.backgroundColor = UIColor.FoodyFlow.white
        inviteUser.setTitle("與好友參與時光", for: .normal)
        inviteUser.setTitleColor(UIColor.FoodyFlow.darkOrange, for: .normal)
    }
    
    @objc func createRefrig() {
        cameraAc3tion()
    }
    
    func cameraAc3tion() {
         // User create // Refrige Create
        
            RefrigeManager.shared.createFrige(refrige: &self.refrige) { result in
            switch result {
            case .success(let refrigeID):
                guard let useID = Auth.auth().currentUser?.uid else { return }
                self.fetchUser(userID: useID) { userInfo in
                    var personalRefirge = userInfo.personalRefrige
                        personalRefirge.append(refrigeID)
                    UserManager.shared.createRefrigeOnSingleUser(user: userInfo, refrigeID: personalRefirge) { result in
                        switch result {
                        case .success:
                            self.verifyUser {
                                HandleResult.addDataSuccess.messageHUD

                            }
                        case .failure:
                            HandleResult.addDataFailed.messageHUD
                        }
                    }
                }
//                self.onPublished?()
            case .failure:
                HandleResult.addDataFailed.messageHUD
                
            }
            }
            
        
        }
    
    func fetchUser(userID: String, completion: @escaping (UserInfo) -> Void) {
        UserManager.shared.fetchUserInfo(fetchUserID: userID) { result in
            
            switch result {
            case.success(let userInfo):
                completion(userInfo)
            case.failure:
                print(LocalizedError.self)
            }
        }
    }
    
    func verifyUser( completion: @escaping () -> Void) {
        Auth.auth().addStateDidChangeListener { ( _, user) in
            if user != nil {
                guard let user = user?.uid else {
                    return
                }
                self.fetchUserByUserID(userID: user) { _ in
                    completion()
                }
                                
            } else {
                self.present( LoginViewController(), animated: true )
                completion()
            }
        }
        
    }
    
    func fetchUserByUserID(userID: String, completion: @escaping (UserInfo) -> Void ) {
        
        self.fetchUser(userID: userID) { userInfo in
//            self.fetchAllRefrige(userRefriges: userInfo.personalRefrige)
//            self.personalName.text = userInfo.userName
            // self.personalImage.image = UIImage
            // User photo
            
        }
            
    }




    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inviteUser.lkCornerRadius = 20
        createUser.lkCornerRadius = 20
        inviteUser.isHidden = true 
    }
    
    @objc func imageTapped( tapGestureRecognizer: UITapGestureRecognizer ) {
        _ = tapGestureRecognizer.view as? UIImageView
    }
    
}
