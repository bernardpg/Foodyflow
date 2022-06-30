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
    private let background = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
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
        print("refrige")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inviteUser.lkCornerRadius = 20
        createUser.lkCornerRadius = 20
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let tappedImage = tapGestureRecognizer.view as? UIImageView
    }
    
}
