//
//  RefrigeAllFoodViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/26/22.
//

// 還沒有購買得時候 購買完須在點擊才會有改變backgroundPage
// 新增食物crash
// delefood in refrige

// 刪除冰箱食物 login

// 將所有 fetch 資料傳下去
// filter 
// 點擊進去更新
// fetch 回來依照食物

import UIKit
import FirebaseAuth
import Kingfisher

class RefrigeAllFoodViewController: UIViewController {
    
    var refrigeTableView = UITableView() { didSet { refrigeTableView.reloadData() } }
    
    private var tapButton = UIButton()
    
    private let authManager = AuthManager()
    
    private let userManager = UserManager()
    
    var refrige: [Refrige] = []
    
    var completion: CompletionHandler?
    
    var cate: [String?] = []
    
    var arry = [[FoodInfo]]()
    
    var foodsInfo: [FoodInfo] = []
    
    var meatsInfo: [FoodInfo] = []
    
    var beansInfo: [FoodInfo] = []
    
    var eggsInfo: [FoodInfo] = []
    
    var vegsInfo: [FoodInfo] = []
    
    var picklesInfo: [FoodInfo] = []
    
    var fruitsInfo: [FoodInfo] = []
    
    var fishesInfo: [FoodInfo] = []
    
    var seafoodsInfo: [FoodInfo] = []
    
    var beveragesInfo: [FoodInfo] = []
    
    var seasonsInfo: [FoodInfo] = []
    
    var othersInfo: [FoodInfo] = []
    
    var searchView = SearchPlaceholderView()
    
    var tabIndex: Int?
    
    var onPublished: (() -> Void)?
    
    var foodDetail: ((String) -> Void)?  // callback
    
    var didSelectDifferentRef: Int? { didSet { reloadRefrige() } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        refrigeTableView.register(RefrigeCatTableViewCell.nib(), forCellReuseIdentifier: "refrigeCatTableViewCell")
        refrigeTableView.delegate = self
        refrigeTableView.dataSource = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refrigeTableView.layoutIfNeeded()
        tapButton.layer.cornerRadius = (tapButton.frame.height)/2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // lottie 開始
        
        singlerefrige()
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func singlerefrige() {
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let semaphore = DispatchSemaphore(value: 0)
        
        DispatchQueue.global().async {
            self.fetchAllCate { [weak self] cate in
                self?.cate = cate
                semaphore.signal()
            }
            semaphore.wait()
            // fetch User fetch Refrige
        self.userManager.fetchUserInfo(fetchUserID: userID) { result in
            switch result {
            case .success(let userInfo):
                self.fetchAllRefrige(userRefriges: userInfo.personalRefrige) { [weak self] refrige in
                    self?.resetRefrigeFood()
                    self?.fetAllFood(completion: { foodInfo in
                        
                        guard let cates = self?.cate else { return }
                        
                        self?.cateFilter(allFood: foodInfo, cates: cates)
                        
                        DispatchQueue.main.async {
                            // lottie 消失
                            self?.refrigeTableView.reloadData()
                            
//                            refrigeNow = self?.refrige[0]
                            
                           semaphore.signal()
                        }
                    })
                        
                    }
                
                case .failure:
                    HandleResult.readDataFailed.messageHUD
                
                }
            }
            semaphore.wait()
        }
    }
    
    private func cateOfCount() -> Int {
        var count: Int = 0
        if meatsInfo.count > 0 {
            count += 1
        }
        if beansInfo.count > 0 {
            count += 1
        }
        if eggsInfo.count > 0 {
            count += 1
        }
        if vegsInfo.count > 0 {
            count += 1
        }
        if picklesInfo.count > 0 {
            count += 1
        }
        if fruitsInfo.count > 0 {
            count += 1
        }
        if fishesInfo.count > 0 {
            count += 1
        }
        if seafoodsInfo.count > 0 {
            count += 1
        }
        if beveragesInfo.count > 0 {
            count += 1
        }
        if seasonsInfo.count > 0 {
            count += 1
        }
        if othersInfo.count > 0 {
            count += 1
        }
        return count

    }

    private func reloadRefrige() {
        
        HandleResult.readData.messageHUD
        let semaphore = DispatchSemaphore(value: 0)
        
        DispatchQueue.global().async {
            
            self.resetRefrigeFood()
            
            self.fetAllFood(completion: { foodinfo21 in
//                HandleResult.readDataFailed.messageHUD
                self.cateFilter(allFood: foodinfo21, cates: self.cate)
                if foodinfo21.isEmpty {
                    self.refrigeTableView.isHidden = true
                    self.view.addSubview(self.searchView)
                    self.searchView.isHidden = false
                    self.searchView.translatesAutoresizingMaskIntoConstraints = false
                    self.searchView.leadingAnchor.constraint(
                        equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,
                        constant: 0).isActive = true
                    self.searchView.trailingAnchor.constraint(
                        equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,
                        constant: 0).isActive = true
                    self.searchView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
                    self.searchView.bottomAnchor.constraint(
                        equalTo: self.view.bottomAnchor,
                        constant: -300).isActive = true } else {
                DispatchQueue.main.async {
                    // lottie 消失
                    if foodinfo21[0].foodId != nil {
                        self.searchView.isHidden = true
                        self.refrigeTableView.isHidden = false
                        self.refrigeTableView.reloadData() } else {
                        self.refrigeTableView.isHidden = true
                        self.view.addSubview(self.searchView)
                        self.searchView.isHidden = false
                        self.searchView.translatesAutoresizingMaskIntoConstraints = false
                        self.searchView.leadingAnchor.constraint(
                            equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,
                            constant: 0).isActive = true
                        self.searchView.trailingAnchor.constraint(
                            equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,
                            constant: 0).isActive = true
                        self.searchView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
                        self.searchView.bottomAnchor.constraint(
                            equalTo: self.view.bottomAnchor,
                            constant: -300).isActive = true
                    }
//                    guard let didSelectDifferentRef = self.didSelectDifferentRef else { return }
//                    refrigeNow = self.refrige[didSelectDifferentRef]
                    semaphore.signal()
                    
                }}
                
            })
            
            semaphore.wait()
        }
    }
    
    // change refrige
    //    refrigeNow = refrige[0]
    func verifyUser() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                let shoppingVC = RefrigeProductDetailViewController(
                    nibName: "ShoppingProductDetailViewController",
                    bundle: nil)
                
                // bug fixs
                guard let currentRefrige = refrigeNow else { return }
                shoppingVC.refrige = currentRefrige
                self.navigationController!.pushViewController(shoppingVC, animated: true)
                
            } else {
                self.present(LoginViewController(), animated: true)
                
            }
        }
        
    }
    
    func verifyUserloading( completion: @escaping () -> Void) {
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
    
    func fetchUserByUserID(userID: String, completion: @escaping (UserInfo) -> Void) {
        
        self.fetchUser(userID: userID) { userInfo in
            self.fetchAllRefrige(userRefriges: userInfo.personalRefrige) { _ in
                
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

    @objc func addNewFood() {
        verifyUser()
    }
    
    func fetchAllCate(completion: @escaping([String?]) -> Void) {
        CategoryManager.shared.fetchArticles(completion: { result in
            switch result {
            case .success(let cate):
                completion( cate[0].type )
            case .failure:
                print("cannot fetceeeeh data")
            }
        })
    }
    
    func userLoadRefrige(userID: String) {
        self.userManager.fetchUserInfo(fetchUserID: userID) { result in
            switch result {
            case .success(let userInfo):
                self.fetchAllRefrige(userRefriges: userInfo.personalRefrige) { [weak self] refrige in
                                                                        
                    DispatchQueue.main.async {
                                    // lottie 消失
                    self?.refrigeTableView.reloadData()
                                    
                    refrigeNow = self?.refrige[0]
                    }
                }
            case .failure:
                        HandleResult.readDataFailed.messageHUD
            }
        }
    }
    
    func fetchAllRefrige(userRefriges: [String?], completion: @escaping (CompletionHandler)) {
        RefrigeManager.shared.fetchArticles(userRefrige: userRefriges) { [weak self] result in
            switch result {
            case .success(let refrige):
                self?.refrige = refrige
                completion(["refrige": refrige])
            case .failure:
                print("cannot fetch data")
            }
        }
    }

    func fetAllFood(completion: @escaping([FoodInfo]) -> Void) {
        self.foodsInfo = []
//        print(self.refrige[self.didSelectDifferentRef ?? 0])
        FoodManager.shared.fetchSpecifyFood(refrige: refrigeNow!) { [weak self] result in
            switch result {
            case .success(let foodInfo):
            if ((foodInfo.foodId?.isEmpty) != nil) {                self?.foodsInfo.append(foodInfo)
                    if self?.foodsInfo.count == refrigeNow!.foodID.count {
                    completion(self?.foodsInfo ?? [foodInfo])}
                    else {print("append not finish yet ")}}
                else {completion([foodInfo])}
            case .failure:
                print("fetch food error")
            }
        }
    }
    
    private func resetRefrigeFood() {
        meatsInfo = []
        beansInfo = []
        eggsInfo = []
        vegsInfo = []
        picklesInfo = []
        fruitsInfo = []
        fishesInfo = []
        seafoodsInfo = []
        beveragesInfo = []
        seasonsInfo = []
        othersInfo = []
        
    }
    
    private func cateFilter(allFood: [FoodInfo], cates: [String?]) {
        for foodInfo in allFood {
            for cate in cates {
                guard let foodCategory = foodInfo.foodCategory
                else { return }
                if foodCategory == cate! && cate! == "肉類"{
                self.meatsInfo.append(foodInfo) } else if
                foodCategory == cate! && cate! == "豆類"{
                self.beansInfo.append(foodInfo) } else if
                foodCategory == cate! && cate! == "雞蛋類"{
                self.eggsInfo.append(foodInfo) } else if
                foodCategory == cate! && cate! == "青菜類"{
                self.vegsInfo.append(foodInfo) } else if
                foodCategory == cate! && cate! == "醃製類"{
                self.picklesInfo.append(foodInfo) } else if
                foodCategory == cate! && cate! == "水果類" {
                self.fruitsInfo.append(foodInfo) } else if
                foodCategory == cate! && cate! == "魚類"{
                self.fishesInfo.append(foodInfo) } else if
                foodCategory == cate! && cate! == "海鮮類" {
                self.seafoodsInfo.append(foodInfo) } else if
                foodCategory == cate! && cate! == "飲料類" {
                self.beveragesInfo.append(foodInfo) } else if
                foodCategory == cate! && cate! == "調味料類" {
                self.seasonsInfo.append(foodInfo)} else if
                foodCategory == cate! && cate! == "其他" {
                self.othersInfo.append(foodInfo)}}
        }
        
    }
    
    private func setUI() {
        view.addSubview(refrigeTableView)
        refrigeTableView.translatesAutoresizingMaskIntoConstraints = false
        refrigeTableView.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
            constant: 0).isActive = true
        refrigeTableView.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
            constant: 0).isActive = true
        refrigeTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        refrigeTableView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: 0).isActive = true
        
        view.addSubview(tapButton)
        tapButton.translatesAutoresizingMaskIntoConstraints = false
        tapButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        tapButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        tapButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        tapButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        tapButton.layer.backgroundColor = UIColor.FoodyFlow.darkOrange.cgColor
        tapButton.setImage(UIImage(systemName: "plus"), for: .normal)
        tapButton.imageView?.tintColor = .white
        tapButton.addTarget(self, action: #selector(addNewFood), for: .touchUpInside)
    }

}

extension RefrigeAllFoodViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cate.count
    }
        
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = refrigeTableView.dequeueReusableCell(withIdentifier: "refrigeCatTableViewCell",
                                                        for: indexPath) as? RefrigeCatTableViewCell
        guard let cell = cell else { return UITableViewCell() }
        cell.cateFood.text = self.cate[indexPath.row]
        cell.cateFood.font =  UIFont(name: "PingFang TC", size: 20)
        
        // need to change for dictionary to solve
        
        // Need to fix
        
        switch indexPath.row {
        case 0:
            cell.configure(with: meatsInfo)
        case 1:
            cell.configure(with: beansInfo)
        case 2:
            cell.configure(with: eggsInfo)
        case 3:
            cell.configure(with: vegsInfo)
        case 4:
            cell.configure(with: picklesInfo)
        case 5:
            cell.configure(with: fruitsInfo)
        case 6:
            cell.configure(with: fishesInfo)
        case 7:
            cell.configure(with: seafoodsInfo)
        case 8:
            cell.configure(with: beveragesInfo)
        case 9:
            cell.configure(with: seasonsInfo)
        case 10:
            cell.configure(with: othersInfo)
        default:
            cell.configure(with: foodsInfo)
        }
        
        cell.index = indexPath.row
        
        cell.didSelectClosure = { [weak self] tabIndex, colIndex in
            guard let tabIndex = tabIndex, let colIndex = colIndex else { return }
            let shoppingVC = RefrigeProductDetailViewController(nibName: "ShoppingProductDetailViewController", bundle: nil)
          //  shoppingVC.foodInfo = 
            self?.navigationController?.pushViewController( shoppingVC, animated: true )
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat { 250.0 }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // UIAlert to didselect or delete
        
    }
}
