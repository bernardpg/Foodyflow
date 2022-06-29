//
//  CreatePersonViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/28/22.
//

import UIKit
import SnapKit

class CreatePersonViewController: UIViewController {
    
    private lazy var createUser = UIButton()
    private lazy var inviteUser = UIButton()
    private lazy var appOutsideIcon = UIView()
    private lazy var appIcon = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()

    }
    
    private func setUI() {
        view.addSubview(createUser)
        createUser.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).offset(80)
            make.width.equalTo(163)
            make.height.equalTo(45)
        }
        createUser.setTitle("建立食光", for: .normal)
        createUser.setTitleColor(UIColor.hexStringToUIColor(hex: "F4943A"), for: .normal)
        createUser.backgroundColor = UIColor.hexStringToUIColor(hex: "FFFFFF")
        
        view.addSubview(inviteUser)
        inviteUser.snp.makeConstraints { make in
            make.centerX.equalTo(createUser.snp.centerX)
            make.centerY.equalTo(createUser.snp.centerY).offset(60)
            make.width.equalTo(163)
            make.height.equalTo(45)
        }
        inviteUser.backgroundColor = UIColor.hexStringToUIColor(hex: "FFFFFF")
        inviteUser.setTitle("與好友參與時光", for: .normal)
        inviteUser.setTitleColor(UIColor.hexStringToUIColor(hex: "F4943A"), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inviteUser.lkCornerRadius = 20
        createUser.lkCornerRadius = 20
    }
    
}
