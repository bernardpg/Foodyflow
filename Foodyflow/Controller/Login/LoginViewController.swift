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

    override func viewDidLoad() {
        super.viewDidLoad()
        setSignInWithAppleButton()

    }
    
    func setSignInWithAppleButton() {
        
        
        view.addSubview(googleButton)
        googleButton.lkCornerRadius = 20
        googleButton.snp.makeConstraints { make in
            make.top.equalTo(view).offset(487)
            make.left.equalTo(view).offset(72)
            make.right.equalTo(view).offset(-71)
            make.bottom.equalTo(view).offset(-196)
        }

        
        view.addSubview(appleButton)
        appleButton.lkCornerRadius = 20
        appleButton.snp.makeConstraints { make in
            make.top.equalTo(googleButton.snp.bottom).offset(17)
            make.centerWithinMargins
        }
        
        
        
    }

}
