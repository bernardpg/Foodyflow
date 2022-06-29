//
//  PersonalViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/20/22.
//
// 字體未完全
import UIKit
import SnapKit
import FirebaseAuth

class PersonalViewController: UIViewController {

    @IBOutlet weak var addRefrigeButton: UIButton!
    
    @IBOutlet weak var personalBackgroundView: UIView!
    @IBOutlet weak var personalImage: UIImageView!
    
    @IBOutlet weak var personalName: UILabel!
    
    @IBOutlet weak var signOut: UIButton!
    
    //private let signOut = UIButton()
    
    private let personalChangeImageView = UIView()
    
    private let personalChangeImageButton = UIButton()
    
    private let personalChangNameButton = UIButton()
    
    private let personalTableView = UITableView()
    
    private let notificationLabel = UILabel()
    
    private let notificationSwitch = UISwitch()
    
    var onPublished: (() -> (Void))?
    
    var refrige = Refrige.init(id: "", title: "robust", foodID: [], createdTime: 0, category: "", shoppingList: [])
    
    var refrigeAmount: [Refrige] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        addRefrigeButton.titleLabel?.text = ""
        addRefrigeButton.layer.backgroundColor = UIColor.white.cgColor

        addRefrigeButton.imageView?.tintColor = UIColor.hexStringToUIColor(hex: "F4943A")
        addRefrigeButton.addTarget(self, action: #selector(addRefri), for: .touchUpInside)
        
        setUI()
        personalTableView.delegate = self
        personalTableView.dataSource = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        addRefrigeButton.lkCornerRadius = addRefrigeButton.frame.height / 2
        addRefrigeButton.titleLabel?.text = ""
        addRefrigeButton.snp.makeConstraints { make in
            make.width.equalTo(45)
            make.height.equalTo(45)
        }
        addRefrigeButton.layer.backgroundColor = UIColor.white.cgColor
        addRefrigeButton.imageView?.tintColor = UIColor.hexStringToUIColor(hex: "F4943A")
        
        personalBackgroundView.lkCornerRadius = personalBackgroundView.frame.height / 2
        personalChangeImageView.lkCornerRadius = personalChangeImageView.frame.height / 2
        personalChangeImageButton.lkCornerRadius = personalChangeImageButton.frame.height / 2
        
        personalImage.layer.cornerRadius = (personalImage.frame.height)/2
        personalChangNameButton.lkCornerRadius = personalChangNameButton.frame.height / 2
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchAllRefrige()
    }
    
    @objc func signOutTap() {
        do {
           try Auth.auth().signOut()
        } catch {
           print(error)
        }
    }
    
    @objc func addRefri() {
        
        openAlert(controller: self, mainTitle: "請選擇", firstTitle: "創建新食光", secondTitle: "邀請加入xxx食光", cancelTitle: "取消")
        cameraAc3tion()
        func cameraAc3tion() {
            RefrigeManager.shared.createFrige(refrige: &self.refrige) { result in
                self.onPublished?()
            }
            fetchAllRefrige()
        }
    }
    
    /*@objc func personalSetting() {
        openAlert(controller: self, mainTitle: "更換個人設定", firstTitle: "更換照片", secondTitle: "更換暱稱", cancelTitle: "取消")
    }*/
    
    func openAlert(
        controller: UIViewController,
        mainTitle: String,
        firstTitle:String,
        secondTitle: String,
        cancelTitle: String) {
        
        let alertController = UIAlertController(title: "\(mainTitle)", message: "", preferredStyle: .alert)
        alertController.view.tintColor = UIColor.gray
        
        // Camera
        let cameraAction = UIAlertAction(title: "\(firstTitle)", style: .default) { _ in
        }
        alertController.addAction(cameraAction)
        
        // Photo
        let photoLibraryAction = UIAlertAction(title: "\(secondTitle)", style: .default) { _ in
        }
        alertController.addAction(photoLibraryAction)
        
        let cancelAction = UIAlertAction(title: "\(cancelTitle)", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        
        controller.present(alertController, animated: true, completion: nil)
    }
    
    private func setUI() {
        
        view.addSubview(signOut)
        
        signOut.snp.makeConstraints { make in
            make.centerY.equalTo(addRefrigeButton.snp.centerY)
//            make.centerX.equalTo()
//            make.leading.equalTo(view.snp.leading).offset(16)
//            make.top.equalTo(view.snp.top).offset(16)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        signOut.setTitle("sign", for: .normal)
        signOut.addTarget(self, action: #selector(signOutTap), for: .touchUpInside)

        personalName.text = "Ryan"
        view.backgroundColor = UIColor.hexStringToUIColor(hex: "F4943A")
        personalImage.image = UIImage(named: "girl")
        personalBackgroundView.backgroundColor = .white
        personalBackgroundView.addSubview(personalChangeImageView)
        personalChangeImageView.backgroundColor = UIColor.hexStringToUIColor(hex: "FCE3CB")
        personalChangeImageView.snp.makeConstraints { make in
            make.leading.equalTo(personalBackgroundView).offset(100)
            make.top.equalTo(personalBackgroundView).offset(98)
            make.trailing.equalTo(personalBackgroundView).offset(-5)
            make.bottom.equalTo(personalBackgroundView).offset(-8)
        }
        
        personalChangeImageView.addSubview(personalChangeImageButton)
        personalChangeImageButton.snp.makeConstraints { make in
            make.leading.equalTo(personalChangeImageView).offset(5)
            make.top.equalTo(personalChangeImageView).offset(5)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        personalChangeImageButton.setImage(UIImage(named: "photo"), for: .normal)
        
        view.addSubview(personalChangNameButton)

        personalChangNameButton.snp.makeConstraints { make in
            make.leading.equalTo(personalName.snp.trailing).offset(5)
            make.centerY.equalTo(personalName.snp.centerY).offset(0)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        personalChangNameButton.setImage(UIImage(named: "pen"), for: .normal)
        
        personalTableView.register(
            UINib(nibName: "PersonalTableViewCell", bundle: nil),
            forCellReuseIdentifier: "PersonalTableViewCell")
        personalTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(personalTableView)
        
        personalTableView.topAnchor.constraint(equalTo: personalName.bottomAnchor, constant: 30).isActive = true
        personalTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        personalTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        personalTableView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -40).isActive = true
        personalTableView.backgroundColor = UIColor.hexStringToUIColor(hex: "F4943A")
        
        view.addSubview(notificationLabel)
        
        notificationLabel.snp.makeConstraints { make in
            make.top.equalTo(personalTableView.snp.bottom).offset(5)
            make.leading.equalTo(view).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(0)
        }
        notificationLabel.text = "開啟即將到期提醒通知"
        view.addSubview(notificationSwitch)
        
        notificationSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(notificationLabel)
            make.leading.equalTo(notificationLabel.snp.trailing).offset(150)
        }
        
        notificationSwitch.addTarget(self, action: #selector(settingNotification), for: .touchUpInside)
        
    }
    
    @objc func settingNotification() {
        // unfinish
        print("dd")
    }
    
    func fetchAllRefrige() {
        RefrigeManager.shared.fetchArticles { [weak self] result in
            switch result {
            case .success(let refrigeAmount):
                self?.refrigeAmount = refrigeAmount
                DispatchQueue.main.async {
                    self?.personalTableView.reloadData()
                }
            case .failure:
                print("cannot fetch data")
            }
        }
    }
    
    func deleteRefrige(needtoRemove: String, completion: @escaping () -> Void ) {
        RefrigeManager.shared.removeFrige(refrigeID: needtoRemove) { result in
            switch result {
            case.success:
                self.fetchAllRefrige()
            case.failure:
                print(LocalizedError.self)
            }
            
        }
        
    }
    
    private func changeRefrige() {
        
    }
}

extension PersonalViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        refrigeAmount.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = personalTableView.dequeueReusableCell(withIdentifier: "PersonalTableViewCell",
            for: indexPath) as? PersonalTableViewCell
        guard let cell = cell else { return UITableViewCell() }
        cell.refreigeName.text = refrigeAmount[indexPath.row].title
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // change refrige
        var removeRefrige = refrigeAmount[indexPath.row].id
        
        deleteRefrige(needtoRemove: "\(removeRefrige)") {
 //           self.fetchAllRefrige()
        }
        // delete refrige
        
    }
    
}
