//
//  RefrigeAllFoodViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/26/22.
//

// delefood in refrige

import UIKit
import FirebaseAuth

class RefrigeAllFoodViewController: UIViewController {
    
    private var refrigeTableView = UITableView() {
        didSet{refrigeTableView.reloadData() }
    }
    private var tapButton = UIButton()
    
    private let authManager = AuthManager()

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
    
    var tabIndex: Int?
    
    var onPublished: (() -> Void)?
    
    var foodDetail: ((String) -> Void)?  // callback
    
    var didSelectDifferentRef: Int? {didSet{reloadRefrige()}}
    
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
        
        let semaphore = DispatchSemaphore(value: 0)
        
        DispatchQueue.global().async {
            self.fetchAllCate { [weak self] cate in
                self?.cate = cate
                semaphore.signal()
            }
            semaphore.wait()
            
            self.fetchAllRefrige { [weak self] refrige in
                
                self?.resetRefrigeFood()
                
                self?.fetAllFood(completion: { foodinfo21 in
                    
                    guard let cates = self?.cate else { return }
                    
                    self?.cateFilter(allFood: foodinfo21, cates: cates)
                    
                    DispatchQueue.main.async {
                        // lottie 消失
                        self?.refrigeTableView.reloadData()
                        
                        refrigeNow = self?.refrige[0]

                        semaphore.signal()
                    }
                })
            }
            semaphore.wait()
        }
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func resetRefrigeFood() {
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
    
    func cateFilter(allFood: [FoodInfo], cates: [String?]) {
        for foodInfo in allFood {
                for cate in cates {
                    guard let foodCategory = foodInfo.foodCategory
                    else { return }
                    if foodCategory == cate! && cate! == "肉類" { self.meatsInfo.append(foodInfo) }
                     else if foodCategory == cate! && cate! == "豆類" { self.beansInfo.append(foodInfo) }
                    else if foodCategory == cate! && cate! == "雞蛋類" { self.eggsInfo.append(foodInfo) }
                    else if foodCategory == cate! && cate! == "青菜類" { self.vegsInfo.append(foodInfo) }
                    else if foodCategory == cate! && cate! == "醃製類" { self.picklesInfo.append(foodInfo) }
                    else if foodCategory == cate! && cate! == "水果類" { self.fruitsInfo.append(foodInfo) }
                    else if foodCategory == cate! && cate! == "魚類" { self.fishesInfo.append(foodInfo) }
                    else if foodCategory == cate! && cate! == "海鮮類" { self.seafoodsInfo.append(foodInfo) }
                    else if foodCategory == cate! && cate! == "飲料類" { self.beveragesInfo.append(foodInfo) }
                    else if foodCategory == cate! && cate! == "調味料類"
                    {self.seasonsInfo.append(foodInfo)}
                    else if foodCategory == cate! && cate! == "其他"
                    {self.othersInfo.append(foodInfo)}
                }
            }

    }

    func setUI() {
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
        
        refrigeTableView.addSubview(tapButton)
        tapButton.translatesAutoresizingMaskIntoConstraints = false
        tapButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        tapButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        tapButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        tapButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        tapButton.layer.backgroundColor = UIColor.hexStringToUIColor(hex:  "F4943A").cgColor
        tapButton.setImage(UIImage(systemName: "plus"), for: .normal)
        tapButton.imageView?.tintColor = .white
//        tapButton.imageView?.backgroundColor = .white
        tapButton.addTarget(self, action: #selector(addNewFood), for: .touchUpInside)
    }
    
    func reloadRefrige() {
        
        let semaphore = DispatchSemaphore(value: 0)
        
        DispatchQueue.global().async {

        self.resetRefrigeFood()
        
        self.fetAllFood(completion: { foodinfo21 in
            
            self.cateFilter(allFood: foodinfo21, cates: self.cate)
            
            DispatchQueue.main.async {
                // lottie 消失
                self.refrigeTableView.reloadData()
                guard let didSelectDifferentRef = self.didSelectDifferentRef else { return }
                refrigeNow = self.refrige[didSelectDifferentRef]
                semaphore.signal()
  
            }
            semaphore.wait()}
        )
        }
    }
    
    // change refrige
//    refrigeNow = refrige[0]
    
    @objc func addNewFood() {
        if let user = Auth.auth().currentUser{
        //guard !userNowID?.isEmpty else { return }
        //authManager.auth.currentUser
        let shoppingVC = RefrigeProductDetailViewController(
        nibName: "ShoppingProductDetailViewController",
        bundle: nil)
        shoppingVC.refrige = refrige[0]
        self.navigationController!.pushViewController(shoppingVC, animated: true)
        }
        else {
            let loginVC = LoginViewController()
            present(loginVC, animated: true)
        }
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
    
    func fetchAllRefrige(completion: @escaping (CompletionHandler)) {
        RefrigeManager.shared.fetchArticles { [weak self] result in
            switch result {
            case .success(let refrige):
                self?.refrige = refrige
                completion(["refrige": refrige])
            case .failure:
                print("cannot fetch data")
            }
        }
    }
    
    // change refrige need to reload
    /*
    func fetAllFood(completion: @escaping([FoodInfo]) -> Void) {
        self.foodsInfo = []
        FoodManager.shared.fetchSpecifyFood(refrige: self.refrige[0]) { [weak self] result in
            switch result {
            case .success(let foodInfo):
                self?.foodsInfo.append(foodInfo)
                if self?.foodsInfo.count == self?.refrige[0].foodID.count {completion(self?.foodsInfo ?? [foodInfo])}
                else {print("append not finish yet ")}
            case .failure:
                print("fetch food error")
            }
        }
    }
     */
    func fetAllFood(completion: @escaping([FoodInfo]) -> Void) {
        self.foodsInfo = []
        FoodManager.shared.fetchSpecifyFood(refrige: self.refrige[self.didSelectDifferentRef ?? 0]) { [weak self] result in
            switch result {
            case .success(let foodInfo):
                if ((foodInfo.foodId?.isEmpty) != nil) {                self?.foodsInfo.append(foodInfo)
                    if self?.foodsInfo.count == self?.refrige[self?.didSelectDifferentRef ?? 0].foodID.count {completion(self?.foodsInfo ?? [foodInfo])}
                    else {print("append not finish yet ")}}
                else {completion([foodInfo])}
            case .failure:
                print("fetch food error")
            }
        }
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
            self?.navigationController?.pushViewController(shoppingVC,animated: true)
            }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat { 250.0 }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // UIAlert to didselect or delete
        
    }
}
