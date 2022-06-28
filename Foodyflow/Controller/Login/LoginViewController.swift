//
//  LoginViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/28/22.
//

import UIKit
import SnapKit
import AuthenticationServices
import FirebaseAuth
import CryptoKit

class LoginViewController: UIViewController {
    
    private lazy var appleButton = UIButton()
    private lazy var googleButton = UIButton()
    private lazy var userTry = UIButton()
    private lazy var appOutsideIcon = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setSignInWithAppleButton()

    }
    
    func setSignInWithAppleButton() {
        
        view.addSubview(appOutsideIcon)
        appOutsideIcon.snp.makeConstraints { make in
//            make.top.equalTo(view).offset(200)
//            make.bottom.equalTo(googleButton.snp.top).offset(151)
//            make.leading.equalTo(view).offset(109)
            make.centerY.equalTo(view).offset(-200)
            make.centerX.equalTo(view)
//            make.trailing.equalTo(view).offset(90)
            make.width.equalTo(300)
            make.height.equalTo(300)
            
        }
        appOutsideIcon.lkCornerRadius = 20
        appOutsideIcon.backgroundColor = .systemPink
                
        view.addSubview(googleButton)
        googleButton.lkCornerRadius = 20
        googleButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(100)
            make.width.equalTo(271)
            make.height.equalTo(53)
        }
        googleButton.backgroundColor = .systemBlue

        view.addSubview(appleButton)
        appleButton.lkCornerRadius = 20
        appleButton.snp.makeConstraints { make in
            make.top.equalTo(googleButton.snp.bottom).offset(17)
            make.centerX.equalTo(googleButton.snp.centerX)
            make.width.equalTo(271)
            make.height.equalTo(53)
        }
        appleButton.backgroundColor = .systemPink
        
        view.addSubview(userTry)
        userTry.snp.makeConstraints { make in
            make.top.equalTo(appleButton.snp.bottom).offset(10)
            make.centerX.equalTo(appleButton.snp.centerX)
            make.width.equalTo(271)
            make.height.equalTo(50)
        }
        userTry.setTitle("以訪客登入使用", for: .normal)
        userTry.setTitleColor(UIColor.systemBlue, for: .normal)
        
    }

}
