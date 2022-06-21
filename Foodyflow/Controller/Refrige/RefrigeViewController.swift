//
//  RefrigeViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/16/22.
//

import UIKit
import CoreMedia
import CoreMIDI

class RefrigeViewController: UIViewController {
    
    private var refrigeTableView = UITableView(){
        didSet{
            refrigeTableView.reloadData()
        }
    }
    
    private var tapButton = UIButton()
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // viewwillappear 打完重劃
        let task1 = DispatchQueue(label: "task1")
        let semaphore = DispatchSemaphore(value: 0)
        task1.async {
            self.fetchAllCate()
            semaphore.signal()
        }
        semaphore.wait()
        task1.async {
            self.fetchAllRefrige { [weak self ] refrige in
                self?.fetAllFood(completion: { foodinfo21 in
                    guard let foodsInfo = self?.foodsInfo else { return }
                    guard let cates = self?.cate else { return }
                    for foodInfo in foodsInfo {
                        for cate in cates {
                            if foodInfo.foodCategory! == cate! && cate! == "肉類"{
                                self?.meatsInfo.append(foodInfo)}
                            else if foodInfo.foodCategory! == cate! && cate! == "豆類"{
                                self?.beansInfo.append(foodInfo)}
                            else if foodInfo.foodCategory! == cate! && cate! == "雞蛋類"{
                                self?.eggsInfo.append(foodInfo)}
                            else if foodInfo.foodCategory! == cate! && cate! == "青菜類"{
                                self?.vegsInfo.append(foodInfo)}
                            else if foodInfo.foodCategory! == cate! && cate! == "醃製類"{
                                self?.picklesInfo.append(foodInfo)}
                            else if foodInfo.foodCategory! == cate! && cate! == "水果類"{
                                self?.fruitsInfo.append(foodInfo)}
                            else if foodInfo.foodCategory! == cate! && cate! == "魚類"{
                                self?.fishesInfo.append(foodInfo)}
                            else if foodInfo.foodCategory! == cate! && cate! == "海鮮類"{
                                self?.seafoodsInfo.append(foodInfo)}
                            else if foodInfo.foodCategory! == cate! && cate! == "飲料類"{
                                self?.beveragesInfo.append(foodInfo)}
                            else if foodInfo.foodCategory! == cate! && cate! == "調味料類"{
                                self?.seasonsInfo.append(foodInfo)}
                            else if foodInfo.foodCategory! == cate! && cate! == "其他"{
                                self?.othersInfo.append(foodInfo)
                            }
                            else {
                            }
                        }
                    }
                    semaphore.signal()
                    DispatchQueue.main.async {
                        self?.arry.append(self?.meatsInfo ?? foodsInfo)
                        self?.arry.append(self?.beansInfo ?? foodsInfo)
                        self?.arry.append(self?.eggsInfo ?? foodsInfo)
                        self?.arry.append(self?.vegsInfo ?? foodsInfo)
                        self?.arry.append(self?.picklesInfo ?? foodsInfo)
                        self?.arry.append(self?.fruitsInfo ?? foodsInfo)
                        self?.arry.append(self?.fishesInfo ?? foodsInfo)
                        self?.arry.append(self?.seafoodsInfo ?? foodsInfo)
                        self?.arry.append(self?.beveragesInfo ?? foodsInfo)
                        self?.arry.append(self?.seasonsInfo ?? foodsInfo)
                        self?.arry.append(self?.othersInfo ?? foodsInfo)
                        self?.refrigeTableView.reloadData()
                    }
                })
            }
            semaphore.signal()
        }
        semaphore.wait()
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // viewwillappear 打完重劃
        let task1 = DispatchQueue(label: "task1")
        let semaphore = DispatchSemaphore(value: 0)
        task1.async {
            self.fetchAllCate()
            semaphore.signal()
        }
        semaphore.wait()
        task1.async {
            self.fetchAllRefrige { [weak self ] refrige in
                self?.fetAllFood(completion: { foodinfo21 in
                    guard let foodsInfo = self?.foodsInfo else { return }
                    guard let cates = self?.cate else { return }
                    for foodInfo in foodsInfo {
                        for cate in cates {
                            if foodInfo.foodCategory! == cate! && cate! == "肉類"{
                                self?.meatsInfo.append(foodInfo)}
                            else if foodInfo.foodCategory! == cate! && cate! == "豆類"{
                                self?.beansInfo.append(foodInfo)}
                            else if foodInfo.foodCategory! == cate! && cate! == "雞蛋類"{
                                self?.eggsInfo.append(foodInfo)}
                            else if foodInfo.foodCategory! == cate! && cate! == "青菜類"{
                                self?.vegsInfo.append(foodInfo)}
                            else if foodInfo.foodCategory! == cate! && cate! == "醃製類"{
                                self?.picklesInfo.append(foodInfo)}
                            else if foodInfo.foodCategory! == cate! && cate! == "水果類"{
                                self?.fruitsInfo.append(foodInfo)}
                            else if foodInfo.foodCategory! == cate! && cate! == "魚類"{
                                self?.fishesInfo.append(foodInfo)}
                            else if foodInfo.foodCategory! == cate! && cate! == "海鮮類"{
                                self?.seafoodsInfo.append(foodInfo)}
                            else if foodInfo.foodCategory! == cate! && cate! == "飲料類"{
                                self?.beveragesInfo.append(foodInfo)}
                            else if foodInfo.foodCategory! == cate! && cate! == "調味料類"{
                                self?.seasonsInfo.append(foodInfo)}
                            else if foodInfo.foodCategory! == cate! && cate! == "其他"{
                                self?.othersInfo.append(foodInfo)
                            }
                            else {
                            }
                        }
                    }
                    semaphore.signal()
                    DispatchQueue.main.async {
                        self?.arry.append(self?.meatsInfo ?? foodsInfo)
                        self?.arry.append(self?.beansInfo ?? foodsInfo)
                        self?.arry.append(self?.eggsInfo ?? foodsInfo)
                        self?.arry.append(self?.vegsInfo ?? foodsInfo)
                        self?.arry.append(self?.picklesInfo ?? foodsInfo)
                        self?.arry.append(self?.fruitsInfo ?? foodsInfo)
                        self?.arry.append(self?.fishesInfo ?? foodsInfo)
                        self?.arry.append(self?.seafoodsInfo ?? foodsInfo)
                        self?.arry.append(self?.beveragesInfo ?? foodsInfo)
                        self?.arry.append(self?.seasonsInfo ?? foodsInfo)
                        self?.arry.append(self?.othersInfo ?? foodsInfo)
                        self?.refrigeTableView.reloadData()
                    }
                })
            }
            semaphore.signal()
        }
        semaphore.wait()
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setUI() {
        view.addSubview(refrigeTableView)
        refrigeTableView.translatesAutoresizingMaskIntoConstraints = false
        refrigeTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        refrigeTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        refrigeTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        refrigeTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                 constant: 0).isActive = true
        
        refrigeTableView.addSubview(tapButton)
        tapButton.translatesAutoresizingMaskIntoConstraints = false
        tapButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        tapButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        tapButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        tapButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        tapButton.backgroundColor = .black
        tapButton.addTarget(self, action: #selector(addNewFood), for: .touchUpInside)
    }
    @objc func addNewFood() {
        let shoppingVC = RefrigeProductDetailViewController(nibName: "ShoppingProductDetailViewController", bundle: nil)
        shoppingVC.refrige = refrige[0]
        self.navigationController!.pushViewController(shoppingVC, animated: true)
        
    }
    
    func fetchAllCate() {
        CategoryManager.shared.fetchArticles(completion: { [weak self] result in
            switch result {
            case .success(let cate):
                self?.cate = cate[0].type
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
    
    func fetAllFood(completion: @escaping([FoodInfo]) -> Void) {
        FoodManager.shared.fetchSpecifyFood(refrige: self.refrige[0]) { [weak self] result in
            switch result {
            case .success(let foodInfo):
                self?.foodsInfo.append(foodInfo)
                if self?.foodsInfo.count == self?.refrige[0].foodID.count {
                    completion(self?.foodsInfo ?? [foodInfo])
                }
                else {
                    print("append  no yet ")
                }
            case .failure:
                print("fetch food error")
            }
        }
    }
}

extension RefrigeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = refrigeTableView.dequeueReusableCell(withIdentifier: "refrigeCatTableViewCell",
                                                        for: indexPath) as? RefrigeCatTableViewCell
        guard let cell = cell else { return UITableViewCell() }
        cell.cateFood.text = self.cate[indexPath.row]
        // need to change for dictionary to solve
        print(arry[indexPath.row])
        
        cell.configure(with: arry[indexPath.row])
        cell.index = indexPath.row
        cell.didSelectClosure = { [weak self] tabIndex, colIndex in
            guard let tabIndex = tabIndex, let colIndex = colIndex else { return }
            let shoppingVC = RefrigeProductDetailViewController(nibName: "ShoppingProductDetailViewController", bundle: nil)
 //           guard let refrige = refrige else { return }
 //           shoppingVC.refrige = refrige.first
            self?.navigationController?.pushViewController(shoppingVC, animated: true)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        250.0
    }
}

/*
 //            guard let text = self?.models[0].foodID[colIndex] else { return }
 //            self?.foodDetail?(text) // callback way
 //            guard let refrige = self?.refrige[0] else { return }
 //           shoppingVC.refrige = refrige
 //            shoppingVC.setFoodName(with: text)
 
 */
