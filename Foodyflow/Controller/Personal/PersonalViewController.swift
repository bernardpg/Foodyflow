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
import SwifterSwift

class PersonalViewController: UIViewController {
    
    @IBOutlet weak var addRefrigeButton: UIButton!
    
    @IBOutlet weak var personalBackgroundView: UIView!
    @IBOutlet weak var personalImage: UIImageView!
    
    @IBOutlet weak var personalName: UILabel!
    
    @IBOutlet weak var signOut: UIButton!
    
    let imagePickerController = UIImagePickerController()
    
    private let background = UIImageView()
    
    private let personalChangeImageView = UIView()
    
    private let personalChangeImageButton = UIButton()
    
    private let personalChangNameButton = UIButton()
    
    private let personalTableView = UITableView()
    
    private let notificationLabel = UILabel()
    
    private let notificationSwitch = UISwitch()
    
    var onPublished: (() -> Void )?
    
    var refrigeName: String?
    
    var userManager = UserManager()
    
    var photoManager = PhotoManager()
    
    var handle: AuthStateDidChangeListenerHandle?
    
    var refrige = Refrige.init(id: "", title: "我的冰箱", foodID: [], createdTime: 0, category: "", shoppingList: [])
    
    var refrigeAmount: [Refrige] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        verifyUser {
            
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(imageTapped(tapGestureRecognizer:)))
        background.isUserInteractionEnabled = true
        background.addGestureRecognizer(tapGestureRecognizer)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        personalTableView.addGestureRecognizer(longPressRecognizer)
        
        addRefrigeButton.addTarget(self, action: #selector(addRefri), for: .touchUpInside)
        
        setupUI()
        personalTableView.delegate = self
        personalTableView.dataSource = self
        personalChangeImageButton.addTarget(self, action: #selector(changeUserImage), for: .touchUpInside)
        personalChangNameButton.addTarget(self, action: #selector(changeUserName), for: .touchUpInside)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        addRefrigeButton.lkCornerRadius = addRefrigeButton.frame.height / 2
        addRefrigeButton.titleLabel?.text = ""
        addRefrigeButton.snp.makeConstraints { make in
            make.width.equalTo(45)
            make.height.equalTo(45)
        }
        addRefrigeButton.layer.backgroundColor = UIColor.FoodyFlow.lightOrange.cgColor
        addRefrigeButton.imageView?.tintColor = UIColor.FoodyFlow.darkOrange
        personalBackgroundView.lkCornerRadius = personalBackgroundView.frame.height / 2
        personalChangeImageView.lkCornerRadius = personalChangeImageView.frame.height / 2
        personalChangeImageButton.lkCornerRadius = personalChangeImageButton.frame.height / 2
        
        personalImage.layer.cornerRadius = (personalImage.frame.height)/2
        personalChangNameButton.lkCornerRadius = personalChangNameButton.frame.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        verifyUser {
            
        }
        
        addRefrigeButton.titleLabel?.text = ""
        addRefrigeButton.setImage(UIImage(systemName: "plus" ), for: .normal)
        // fetch user // fetchRefrige
    }
    
    @objc func changeUserName() {
        guard let  userID = Auth.auth().currentUser?.uid else { return }

        fetchUser(userID: userID) { userInfo in
            self.changeUserNames { userName in
                var userData = userInfo
                userData.userName = userName
                self.userManager.updateUserInfo(user: userData) {
                    self.fetchUserByUserID(userID: userID) { _ in
                    
                    }
                }
                
            }
        }
            
        // update User info 
    }
    
    func fetchUserByUserID( userID :String, completion: @escaping (UserInfo) -> Void ){
        
        self.fetchUser(userID: userID) { userInfo in
            self.fetchAllRefrige(userRefriges: userInfo.personalRefrige)
            self.personalName.text = userInfo.userName
            // self.personalImage.image = UIImage
            // User photo
            
        }
            
    }
    
    // MARK: ERRor
    @objc func changeUserImage() {
        
        photoManager.tapPhoto(controller: self, alertText: "選擇個人照片", imagePickerController: imagePickerController)
        // update user info
    }
    
    func verifyUser( completion: @escaping () -> Void) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                guard let user = user?.uid else {
                    return
                }
                self.fetchUserByUserID(userID: user) { _ in
                
                }
                                
            } else {
                self.present( LoginViewController(), animated: true )
                completion()
            }
        }
        
    }
    
    @objc func signOutTap() {
        
    let alert = UIAlertController(title: "用戶設定",
                                message: nil,
                                preferredStyle: .alert)
    let deleteAction = UIAlertAction(title: "刪除帳號", style: .destructive) { _ in
        print("delete")}
    alert.addAction(deleteAction)
        
    let falseAction = UIAlertAction(title: "取消", style: .cancel)
        alert.addAction(falseAction)
    
    let logoutAction = UIAlertAction(title: "登出", style: .default) { _  in
        self.signout()
        }
    alert.addAction(logoutAction)
    alert.show(animated: true, vibrate: false)
 
    }
    
    func signout() {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                dismiss(animated: true, completion: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }

    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        _ = tapGestureRecognizer.view as? UIImageView
    }
    @objc func addRefri() {
        
        verifyUser {
            self.openAlert(controller: self,
                           mainTitle: "請選擇",
                           firstTitle: "創建新食光",
                           secondTitle: "邀請加入xxx食光",
                           cancelTitle: "取消")
        }
        cameraAc3tion()}
    func cameraAc3tion() {
         // User create // Refrige Create
        
            RefrigeManager.shared.createFrige(refrige: &self.refrige) { result in
            switch result {
            case .success(let refrigeID):
                guard let useID = Auth.auth().currentUser?.uid else { return }
                self.fetchUser(userID: useID) { userInfo in
                    var personalRefirge = userInfo.personalRefrige
                        personalRefirge.append(refrigeID)
                    self.userManager.createRefrigeOnSingleUser(user: userInfo, refrigeID: personalRefirge) { result in
                        switch result{
                        case .success(_ ):
                            self.verifyUser {
                                HandleResult.addDataSuccess.messageHUD

                            }
                    case .failure:
                            HandleResult.addDataFailed.messageHUD
                        }
                    }
                }
                self.onPublished?()
            case .failure:
                HandleResult.addDataFailed.messageHUD
                
            }
            }
        
        }
        
    func fetchUser(userID: String, completion: @escaping (UserInfo) -> Void) {
        userManager.fetchUserInfo(fetchUserID: userID) { result in
            
            switch result {
            case.success(let userInfo):
                completion(userInfo)
            case.failure:
                print(LocalizedError.self)
            }
        }
    }
    
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
    
    private func setupUI() {
        view.addSubview(background)
        background.addSubview(addRefrigeButton)
        background.addSubview(personalBackgroundView)
        background.addSubview(personalName)
        background.isUserInteractionEnabled = true
        
        background.image = UIImage(named: "memberback")
        background.snp.makeConstraints { make in
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
            make.top.equalTo(view).offset(-30)
        }
        background.addSubview(signOut)
        signOut.setImage(
            UIImage(named: "setting")?
            .resize(to: .init(width: 32, height: 32)),
            for: .normal
        )
        
        signOut.snp.makeConstraints { make in
            make.centerY.equalTo(addRefrigeButton.snp.centerY)
            make.width.equalTo(100)
            make.height.equalTo(60)
        }
        
        signOut.addTarget(self, action: #selector(signOutTap), for: .touchUpInside)
        
        personalName.text = "Ryan"
        view.backgroundColor = UIColor.FoodyFlow.darkOrange
        personalImage.image = UIImage(named: "girl")
        personalBackgroundView.backgroundColor = .white
        personalBackgroundView.addSubview(personalChangeImageView)
        personalChangeImageView.backgroundColor = UIColor.FoodyFlow.lightOrange
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
        
        background.addSubview(personalChangNameButton)
        
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
        
        personalTableView.topAnchor.constraint(equalTo: personalName.bottomAnchor, constant: 100).isActive = true
        personalTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        personalTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        personalTableView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -40).isActive = true
        personalTableView.backgroundColor = UIColor.FoodyFlow.white
        
        background.addSubview(notificationLabel)
        
        notificationLabel.snp.makeConstraints { make in
            make.top.equalTo(personalTableView.snp.bottom).offset(5)
            make.leading.equalTo(view).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(0)
        }
        notificationLabel.text = "開啟即將到期提醒通知"
        background.addSubview(notificationSwitch)
        
        notificationSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(notificationLabel)
            make.leading.equalTo(notificationLabel.snp.trailing).offset(120)
        }
        
        notificationSwitch.addTarget(self, action: #selector(settingNotification), for: .touchUpInside)
        
    }
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: personalTableView)
            if let indexPath = personalTableView.indexPathForRow(at: touchPoint) {
                changeRefirge(indexPathRow: indexPath.row)
            }
        }
    }
    
    // MARK: 確認是否可以
    private func changeRefirge( indexPathRow: Int ) {
        
        let alert = UIAlertController(title: "更換冰箱",
                                      message: "是否更換\(refrigeAmount[indexPathRow].title)冰箱",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _  in
            refrigeNowID = self.refrigeAmount[indexPathRow].id}
        alert.addAction(okAction)
        let falseAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(falseAction)
        
        alert.show(animated: true, vibrate: true)
    }
    
    @objc func settingNotification() {
        // unfinish
        print("dd")
    }
    
    func changeUserNames(completion: @escaping (String) -> Void) {
        let alertVC = UIAlertController(title: "變更你使用者姓名", message: nil, preferredStyle: .alert)
        alertVC.addTextField()
        
        let submitAction = UIAlertAction(title: "確認", style: .default) { [unowned alertVC] _ in
            let answer = alertVC.textFields![0]
            
            guard let rename = answer.text else { return }
            completion(rename)
            // do something interesting with "answer" here
        }
        
        alertVC.addAction(submitAction)
        
        let falseAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertVC.addAction(falseAction)
        
        present(alertVC, animated: true)
    }

    func fetchAllRefrige(userRefriges: [String?]) {
        RefrigeManager.shared.fetchArticles(userRefrige: userRefriges) { [weak self] result in
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
    
    func deleteRefrige(userInfo: UserInfo,needtoRemove: String, completion: @escaping () -> Void ) {
        // User delete // refrige delete
        //var newshoppingList = foodsInfos.filter { $0 != foodId }
        var newUserInfo = userInfo
        newUserInfo.personalRefrige =  userInfo.personalRefrige.filter{ $0 != needtoRemove }
        userManager.updateUserInfo(user: newUserInfo) {
        }
        
        RefrigeManager.shared.removeFrige(refrigeID: needtoRemove) { result in
            switch result {
            case.success:
                print("ddd")
                
                self.verifyUser {
                    
                }
            case.failure:
                print(LocalizedError.self)
            }
            
        }
    }
    
    private func changeRefrigeName( needtoRename: String, name: String ) {
        RefrigeManager.shared.renameFrige(refrigeID: needtoRename, name: name) {
            self.verifyUser {
                
            }
        }
    }
}

extension PersonalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        refrigeAmount.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = personalTableView.dequeueReusableCell(withIdentifier: "PersonalTableViewCell",
                                                         for: indexPath) as? PersonalTableViewCell
        guard let cell = cell else { return UITableViewCell() }
        cell.indexPath = indexPath
        cell.selectionStyle  = .none
        cell.delegate = self
        cell.refreigeName.text = refrigeAmount[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension PersonalViewController: SelectCellDelegate {
    func didDeleteTap(indexPathRow: IndexPath) {
        let removeRefrige = refrigeAmount[indexPathRow.row].id
        fetchUser(userID: Auth.auth().currentUser?.uid ?? "") { userInfo in
            self.deleteRefrige(userInfo: userInfo, needtoRemove: "\(removeRefrige)") {
            }

        }
    }
    
    func didChangeName(indexPathRow: IndexPath) {
        let renameRefrige = refrigeAmount[indexPathRow.row].id
        
        promptForAnswer {[ weak self ] refrigeChangeName in
            self?.changeRefrigeName(needtoRename: "\(renameRefrige)", name: refrigeChangeName )
        }
        
    }
    
    func promptForAnswer(completion: @escaping (String) -> Void) {
        let alertVC = UIAlertController(title: "變更你食光的名字", message: nil, preferredStyle: .alert)
        alertVC.addTextField()
        
        let submitAction = UIAlertAction(title: "確認", style: .default) { [unowned alertVC] _ in
            let answer = alertVC.textFields![0]
            
            guard let rename = answer.text else { return }
            completion(rename)
            // do something interesting with "answer" here
        }
        
        alertVC.addAction(submitAction)
        
        let falseAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertVC.addAction(falseAction)
        present(alertVC, animated: true)
    }
    
}

extension PersonalViewController: UIImagePickerControllerDelegate {
    
    internal func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.personalImage.image = image
        }
        
        picker.dismiss(animated: true)
    }
}
