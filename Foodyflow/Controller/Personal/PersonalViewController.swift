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
    
    @IBOutlet weak var personalImage: UIImageView!
    
    @IBOutlet weak var personalName: UILabel!
    
    private let personalTableView = UITableView()
    
    private let notificationLabel = UILabel()
    
    private let notificationSwitch = UISwitch()
    
    var onPublished: (()->(Void))?
    
    var refrige = Refrige.init(id: "", title: "robust", foodID: [], createdTime: 0, category: "", shoppingList: [])
    
    var refrigeAmount: [Refrige] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRefrigeButton.addTarget(self, action: #selector(addRefri), for: .touchUpInside)
        
        personalSettingButton.addTarget(self, action: #selector(personalSetting), for: .touchUpInside)
        
        setUI()
        personalTableView.delegate = self
        personalTableView.dataSource = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        personalImage.layer.cornerRadius = (personalImage.frame.height)/2
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAllRefrige()
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
    
    @objc func personalSetting() {
        openAlert(controller: self, mainTitle: "更換個人設定", firstTitle: "更換照片", secondTitle: "更換暱稱", cancelTitle: "取消")
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
    
    private func setUI() {
        
        personalTableView.register(UINib(nibName: "PersonalTableViewCell", bundle: nil), forCellReuseIdentifier: "PersonalTableViewCell")
        personalTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(personalTableView)
        personalTableView.topAnchor.constraint(equalTo: personalName.bottomAnchor, constant: 30).isActive = true
        personalTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        personalTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        personalTableView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -40).isActive = true
//        personalTableView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        personalTableView.backgroundColor = .lightGray
        
        notificationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(notificationLabel)
        
        notificationLabel.topAnchor.constraint(
            equalTo: personalTableView.bottomAnchor,
            constant:  5).isActive = true
        notificationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        notificationLabel.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: 0).isActive = true
        notificationLabel.text = "開啟菜價提醒通知"
        notificationSwitch.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(notificationSwitch)
        
        notificationSwitch.centerYAnchor.constraint(equalTo: notificationLabel.centerYAnchor).isActive = true
        notificationSwitch.leadingAnchor.constraint(equalTo: notificationLabel.trailingAnchor, constant: 150).isActive = true
        notificationSwitch.addTarget(self, action: #selector(settingNotification), for: .touchUpInside)
        
    }
    
    @objc func settingNotification() {
        print("dd")
    }
    
    func fetchAllRefrige(){
        RefrigeManager.shared.fetchArticles { [weak self] result in
            switch result{
            case .success(let refrigeAmount):
                self?.refrigeAmount = refrigeAmount
                DispatchQueue.main.async{
                    self?.personalTableView.reloadData()
                }
            case .failure:
                print("cannot fetch data")
            }
        }
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
    
}
