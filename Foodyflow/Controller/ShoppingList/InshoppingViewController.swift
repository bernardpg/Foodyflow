//
//  InshoppingViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/26/22.
//
// delete food // 點進去 

import UIKit
import Kingfisher

class InshoppingViewController: UIViewController {
        
    var tabIndex: Int?
    
    var cate: [String?] = []
    
    var foodManager = FoodManager.shared
    
    var shopDidSelectDifferentRef: Int? { didSet { reloadShoppingList() } }
      
    // 狀態有改 reload filter 之後的篩選
    
    var shoppingLists: [String?] = []
    
    var foodsInShoppingList: [String?] = []
    
    var inshoppingListView = ShoppingListView()
    
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
    
    var onPublished: (() -> Void)?
    
    @IBOutlet weak var inShoppingListCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inShoppingListCollectionView.delegate = self
        inShoppingListCollectionView.dataSource = self }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        inShoppingListCollectionView.layoutIfNeeded() }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let semaphore = DispatchSemaphore(value: 0)
        
        DispatchQueue.global().async { self.fetchAllCate { [weak self] cate in  self?.cate = cate }
            
            self.fetchAllShoppingListInSingleRefrige { [weak self] shoppingLists in
            self?.shoppingLists = shoppingLists
            if shoppingLists.isEmpty {
                    DispatchQueue.main.async {
                        self?.cate = []
                        self?.inShoppingListCollectionView.backgroundView = self?.inshoppingListView
                        self?.inShoppingListCollectionView.reloadData()
                    }} else {
            shoppingListNowID = self?.shoppingLists[self?.shopDidSelectDifferentRef ?? 0]
                self?.fetchAllFoodInfoInSingleShopList { [weak self] foodssInfo in
                    if foodssInfo.isEmpty {
                        self?.inShoppingListCollectionView.backgroundView = self?.inshoppingListView
                    } else {
                    if foodssInfo[0] == "" {
                        self?.inShoppingListCollectionView.backgroundView = self?.inshoppingListView } else {
                        
                        self?.inShoppingListCollectionView.backgroundView = nil
                        self?.fetAllFood(foodID: foodssInfo, completion: { allfoodInfo in
                        let inshopFoodInfo = allfoodInfo.filter { foodinfo in
                            foodinfo.foodStatus == 2
                            }
                        if  inshopFoodInfo.isEmpty {
                                DispatchQueue.main.async {
                                    self?.cate = []
                                    // lottie 消失
                                    self?.inShoppingListCollectionView.reloadData()
                                    self?.inShoppingListCollectionView.backgroundView = self?.inshoppingListView }
                            }

                        guard let cates = self?.cate else { return }
                        self?.resetRefrigeFood()
                        self?.cateFilter(allFood: inshopFoodInfo, cates: cates)
                        DispatchQueue.main.async {
                            // lottie 消失
                            self?.inShoppingListCollectionView.reloadData()
                            semaphore.signal()
                        }
                    })
                    }

                }
            }
            }
    
            }
            semaphore.wait()

        }
    }

    @objc func addNewFood() {
        
        let shoppingVC = ShoppingListProductDetailViewController(
            nibName: "ShoppingListProductDetailViewController",
            bundle: nil)
        
        shoppingVC.shoppingList.foodID = foodsInShoppingList
        self.navigationController!.pushViewController(shoppingVC, animated: true)
    }
    
    // MARK: reset filter
    
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
            switch foodInfo.foodCategory {
            case CategoryType.meat.description:
                self.meatsInfo.append(foodInfo)
            case CategoryType.beans.description:
                self.beansInfo.append(foodInfo)
            case CategoryType.eggs.description:
                self.eggsInfo.append(foodInfo)
            case CategoryType.vegs.description:
                self.vegsInfo.append(foodInfo)
            case CategoryType.pickles.description:
                self.picklesInfo.append(foodInfo)
            case CategoryType.fruit.description:
                self.fruitsInfo.append(foodInfo)
            case CategoryType.fishes.description:
                self.fishesInfo.append(foodInfo)
            case CategoryType.seafoods.description:
                self.seafoodsInfo.append(foodInfo)
            case CategoryType.beverage.description:
                self.beveragesInfo.append(foodInfo)
            case CategoryType.seasons.description:
                self.seasonsInfo.append(foodInfo)
            case CategoryType.others.description:
                self.othersInfo.append(foodInfo)
            case .none:
                HandleResult.addDataFailed.messageHUD
            case .some:
                HandleResult.addDataFailed.messageHUD
            }
        }
        }

    func fetchAllCate(completion: @escaping([String?]) -> Void) {
        CategoryManager.shared.fetchArticles(completion: { result in
            switch result {
            case .success(let cate):
                completion( cate[0].type )
            case .failure:
                print("cannot fetch cate data")
            }
        })
    }
    
    // MARK: -
    
    private func reloadShoppingList() {
        
        self.fetchAllCate { [weak self] cates in self?.cate = cates  }
    
        self.resetRefrigeFood()
        
        self.fetchAllShoppingListInSingleRefrige { [weak self] shoppingList in
            self?.shoppingLists = shoppingList
            shoppingListNowID = self?.shoppingLists[self?.shopDidSelectDifferentRef ?? 0]
            self?.fetchAllFoodInfoInSingleShopList { [weak self] foodssInfo in
                if foodssInfo.isEmpty {
                self?.inShoppingListCollectionView.backgroundView = self?.inshoppingListView } else {
                if foodssInfo[0] == "" {
                DispatchQueue.main.async {
                    self?.cate = []
                        // lottie 消失
                    self?.inShoppingListCollectionView.reloadData()
                    self?.inShoppingListCollectionView.backgroundView = self?.inshoppingListView } } else {
                    self?.inShoppingListCollectionView.backgroundView = nil
                    self?.fetAllFood(foodID: foodssInfo, completion: { allfoodInfo in
                        let inshopFoodInfo = allfoodInfo.filter { foodinfo in
                            foodinfo.foodStatus == 2 }
                        if  inshopFoodInfo.isEmpty {
                            DispatchQueue.main.async {
                                self?.cate = []
                                // lottie 消失
                                self?.inShoppingListCollectionView.reloadData()
                                self?.inShoppingListCollectionView.backgroundView = self?.inshoppingListView }
                        }

                        guard let cates = self?.cate else { return }
                        self?.resetRefrigeFood()
                        self?.cateFilter(allFood: inshopFoodInfo, cates: cates)
                        DispatchQueue.main.async {
                            // lottie 消失
                            self?.inShoppingListCollectionView.reloadData()
                        }
                    })}
                }
            }}
    }
    // fetch shoppingList number
    private func fetchAllShoppingListInSingleRefrige(completion: @escaping([String?]) -> Void) {
        ShoppingListManager.shared.fetchAllShoppingListIDInSingleRefrige(completion: { result in
          switch result {
          case .success(let shoppingLists):
                completion(shoppingLists)
          case .failure:
            print("fetch shoppingList error")
            }
        })
    }
    
    // fetch single shoppingList FoodInfo
    func fetchAllFoodInfoInSingleShopList(completion: @escaping([String?]) -> Void) {
        ShoppingListManager.shared.fetchfoodInfoInsideSingleShoppingList { result in
            switch result {
            case .success(let foodsInfo):
                self.foodsInShoppingList = foodsInfo
                completion(foodsInfo)
                
            case .failure:
            print("fetch shoppingList error")
                
            }
        }
    }
    
//    shoppingListNowID
    func fetAllFood(foodID: [String?], completion: @escaping([FoodInfo]) -> Void) {
        self.foodsInfo = []
        foodManager.fetchSpecifyFoodInShopping(foods: foodID, completion: { result in
            switch result {
            case .success(let foodsinfo):
                self.foodsInfo.append(foodsinfo)
                if self.foodsInfo.count == self.foodsInShoppingList.count { completion(self.foodsInfo) } else {
                    print("append not finish yet ") }

            case .failure:
                print("fetch shopplinglist food error")
            }
        })
    }
    
    func finishShoppingToRefrige(foodId: String, complection: @escaping(String) -> Void) {
        
        refrigeNow!.foodID.append(foodId) // global
        RefrigeManager.shared.publishFoodOnRefrige(refrige: refrigeNow!) { result in
            switch result {
            case .success:
                // change food status
                self.foodManager.changeFoodStatus(foodId: foodId, foodStatus: 3) {
                    RefrigeManager.shared.fetchSingleRefrigeInfo(refrige: refrigeNow!) { result in
                        switch result {
                        case .success(let refrigeInfo):
                            refrigeNow = refrigeInfo
                            complection(foodId)
                        case .failure:
                            print("cannot fetch cate data")
                        }
                    }
                }
            case .failure(let error):
                
                print("publishArticle.failure: \(error)")
            }
        }
    }
    
    func deleteFoodOnShoppingList(foodId: String, complection: @escaping() -> Void) {
        
        let semaphore = DispatchSemaphore(value: 0)
        
        DispatchQueue.global().async {
        
        self.fetchAllFoodInfoInSingleShopList { foodsInfos in
            
            var newshoppingList: ShoppingList = ShoppingList(
                id: "", title: "", foodID: [""])
            newshoppingList.foodID = foodsInfos.filter { $0 != foodId }
            self.shoppingLists = newshoppingList.foodID

            ShoppingListManager.shared.postFoodOnShoppingList(shoppingList: &newshoppingList) { result in
                switch result {
                case .success:
                    self.fetAllFood(foodID: self.shoppingLists) { allfoodInfo in
                        self.resetRefrigeFood()
                        if let cates = self.cate as? [String] {
                        self.cateFilter(allFood: allfoodInfo, cates: cates)
                            
                        DispatchQueue.main.async {
                            // lottie 消失
                            self.inShoppingListCollectionView.reloadData()
                            complection()
                            semaphore.signal()
                        }
                            
                        }
                    }
                case .failure(let error):
                    print("publishArticle.failure: \(error)")
                }
            }
            
        }
            semaphore.wait()
        }
    }
}

extension InshoppingViewController: UICollectionViewDataSource,
                                      UICollectionViewDelegate,
                                      UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cate.count }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return meatsInfo.count
        case 1:
            return beansInfo.count
        case 2:
            return eggsInfo.count
        case 3:
            return vegsInfo.count
        case 4:
            return picklesInfo.count
        case 5:
            return fruitsInfo.count
        case 6:
            return fishesInfo.count
        case 7:
            return seafoodsInfo.count
        case 8:
            return beveragesInfo.count
        case 9:
           return seasonsInfo.count
        case 10:
          return othersInfo.count
        default:
          return foodsInfo.count
        }
        }
        
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "shoppingListCollectionViewCell",
                for: indexPath) as? ShoppingListCollectionViewCell
        guard let cell = cell else { return UICollectionViewCell() }
        
        cell.layer.backgroundColor = UIColor(red: 1, green: 0.964, blue: 0.929, alpha: 1).cgColor
        cell.layer.cornerRadius = 20
        cell.shoppingItemImage.lkCornerRadius = 20
        
        guard let section = CategoryType(rawValue: indexPath.section) else {
            assertionFailure()
        return UICollectionViewCell() }
        switch section {
        case .meat:
            cell.shoppingName.text = meatsInfo[indexPath.item].foodName
            cell.shoppingItemImage.kf.setImage(with: URL( string: meatsInfo[indexPath.item].foodImages ?? "" ))
            cell.shoppingBrand.text = meatsInfo[indexPath.item].foodBrand
            cell.shoppingLocation.text = meatsInfo[indexPath.item].foodPurchasePlace
            cell.shoppingWeight.isHidden = true  // meatsInfo[indexPath.item].foodWeightAmount
        case .beans:
            cell.shoppingName.text = beansInfo[indexPath.item].foodName
            cell.shoppingItemImage.kf.setImage(with: URL( string: beansInfo[indexPath.item].foodImages ?? "" ))
            cell.shoppingBrand.text = beansInfo[indexPath.item].foodBrand
            cell.shoppingLocation.text = beansInfo[indexPath.item].foodPurchasePlace
            cell.shoppingWeight.isHidden = true
        case .eggs:
            cell.shoppingName.text = eggsInfo[indexPath.item].foodName
            cell.shoppingItemImage.kf.setImage(with: URL( string: eggsInfo[indexPath.item].foodImages ?? "" ))
            cell.shoppingBrand.text = eggsInfo[indexPath.item].foodBrand
            cell.shoppingLocation.text = eggsInfo[indexPath.item].foodPurchasePlace
            cell.shoppingWeight.isHidden = true
        case .vegs:
            cell.shoppingName.text = vegsInfo[indexPath.item].foodName
            cell.shoppingItemImage.kf.setImage(with: URL( string: vegsInfo[indexPath.item].foodImages ?? "" ))
            cell.shoppingBrand.text = vegsInfo[indexPath.item].foodBrand
            cell.shoppingLocation.text = vegsInfo[indexPath.item].foodPurchasePlace
            cell.shoppingWeight.isHidden = true
        case .pickles:
            cell.shoppingName.text = picklesInfo[indexPath.item].foodName
            cell.shoppingItemImage.kf.setImage(with: URL( string: picklesInfo[indexPath.item].foodImages ?? "" ))
            cell.shoppingBrand.text = picklesInfo[indexPath.item].foodBrand
            cell.shoppingLocation.text = picklesInfo[indexPath.item].foodPurchasePlace
            cell.shoppingWeight.isHidden = true
        case .fruit:
            cell.shoppingName.text = fruitsInfo[indexPath.item].foodName
            cell.shoppingItemImage.kf.setImage(with: URL( string: fruitsInfo[indexPath.item].foodImages ?? "" ))
            cell.shoppingBrand.text = fruitsInfo[indexPath.item].foodBrand
            cell.shoppingLocation.text = fruitsInfo[indexPath.item].foodPurchasePlace
            cell.shoppingWeight.isHidden = true
        case .fishes:
            cell.shoppingName.text = fishesInfo[indexPath.item].foodName
            cell.shoppingItemImage.kf.setImage(with: URL( string: fishesInfo[indexPath.item].foodImages ?? "" ))
            cell.shoppingBrand.text = fishesInfo[indexPath.item].foodBrand
            cell.shoppingLocation.text = fishesInfo[indexPath.item].foodPurchasePlace
            cell.shoppingWeight.isHidden = true
        case .seafoods:
            cell.shoppingName.text = seafoodsInfo[indexPath.item].foodName
            cell.shoppingItemImage.kf.setImage(with: URL( string: seafoodsInfo[indexPath.item].foodImages ?? "" ))
            cell.shoppingBrand.text = seafoodsInfo[indexPath.item].foodBrand
            cell.shoppingLocation.text = seafoodsInfo[indexPath.item].foodPurchasePlace
            cell.shoppingWeight.isHidden = true
        case .beverage:
            cell.shoppingName.text = beveragesInfo[indexPath.item].foodName
            cell.shoppingItemImage.kf.setImage(with: URL( string: beveragesInfo[indexPath.item].foodImages ?? "" ))
            cell.shoppingBrand.text = beveragesInfo[indexPath.item].foodBrand
            cell.shoppingLocation.text = beveragesInfo[indexPath.item].foodPurchasePlace
            cell.shoppingWeight.isHidden = true
        case .seasons:
            cell.shoppingName.text = seasonsInfo[indexPath.item].foodName
            cell.shoppingItemImage.kf.setImage(with: URL( string: seasonsInfo[indexPath.item].foodImages ?? "" ))
            cell.shoppingBrand.text = seasonsInfo[indexPath.item].foodBrand
            cell.shoppingLocation.text = seasonsInfo[indexPath.item].foodPurchasePlace
            cell.shoppingWeight.isHidden = true
        case .others:
            cell.shoppingName.text = othersInfo[indexPath.item].foodName
            cell.shoppingItemImage.kf.setImage(with: URL( string: othersInfo[indexPath.item].foodImages ?? "" ))
            cell.shoppingBrand.text = othersInfo[indexPath.item].foodBrand
            cell.shoppingLocation.text = othersInfo[indexPath.item].foodPurchasePlace
            cell.shoppingWeight.isHidden = true
        }
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "ShoppingListCollectionReusableView",
            for: indexPath) as? ShoppingListCollectionReusableView {
            sectionHeader.sectionHeaderlabel.text = cate[indexPath.section]
            sectionHeader.sectionHeaderlabel.font = UIFont(name: "PingFang TC", size: 20)
            return sectionHeader
        }
        return UICollectionReusableView()
    }

    private func collectionView(_ collectionView: UICollectionView,
                                layout collectionViewLayout: UICollectionViewLayout,
                                sizeForItemAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20.0, left: 16.0, bottom: 10.0, right: 16.0)
        }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 200, height: 200) }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let section = CategoryType(rawValue: indexPath.section) else { assertionFailure(); return }
        switch section {
        case .meat:
            finishShoppingToRefrige(foodId: meatsInfo[indexPath.item].foodId ?? "2") { [weak self ] removeFoodID in
                self?.reloadShoppingList()
                self?.deleteFoodOnShoppingList(foodId: removeFoodID, complection: { })
            }
        case .beans:
            finishShoppingToRefrige(foodId: beansInfo[indexPath.item].foodId ?? "2") { [ weak self ] removeFoodID in
                self?.reloadShoppingList()
                self?.deleteFoodOnShoppingList(foodId: removeFoodID, complection: { })
            }
        case .eggs:
            finishShoppingToRefrige(foodId: eggsInfo[indexPath.item].foodId ?? "2") { [ weak self ] removeFoodID in
                self?.reloadShoppingList()
                self?.deleteFoodOnShoppingList(foodId: removeFoodID, complection: { })
            }
        case .vegs:
            finishShoppingToRefrige(foodId: vegsInfo[indexPath.item].foodId ?? "2") { [ weak self ] removeFoodID in
                self?.reloadShoppingList()
                self?.deleteFoodOnShoppingList(foodId: removeFoodID, complection: { })
            }
        case .pickles:
            finishShoppingToRefrige(foodId: picklesInfo[indexPath.item].foodId ?? "2") { [ weak self ] removeFoodID in
                self?.reloadShoppingList()
                self?.deleteFoodOnShoppingList(foodId: removeFoodID, complection: { })
            }
        case .fruit:
            finishShoppingToRefrige(foodId: fruitsInfo[indexPath.item].foodId ?? "2") { [ weak self ] removeFoodID in
                self?.reloadShoppingList()
                self?.deleteFoodOnShoppingList(foodId: removeFoodID, complection: { })
            }
        case .fishes:
            finishShoppingToRefrige(foodId: fishesInfo[indexPath.item].foodId ?? "2") { [ weak self ] removeFoodID in
                self?.reloadShoppingList()
                self?.deleteFoodOnShoppingList(foodId: removeFoodID, complection: { })
            }
        case .seafoods:
            finishShoppingToRefrige(foodId: seafoodsInfo[indexPath.item].foodId ?? "2") { [ weak self ] removeFoodID in
                self?.reloadShoppingList()
                self?.deleteFoodOnShoppingList(foodId: removeFoodID, complection: { })
            }
        case .beverage:
            finishShoppingToRefrige(foodId: beveragesInfo[indexPath.item].foodId ?? "2") { [ weak self ] removeFoodID in
                self?.reloadShoppingList()
                self?.deleteFoodOnShoppingList(foodId: removeFoodID, complection: { })
            }
        case .seasons:
            finishShoppingToRefrige(foodId: seasonsInfo[indexPath.item].foodId ?? "2") { [weak self ] removeFoodID in
                self?.reloadShoppingList()
                self?.deleteFoodOnShoppingList(foodId: removeFoodID, complection: { })
            }
        case .others:
            finishShoppingToRefrige(foodId: othersInfo[indexPath.item].foodId ?? "2") { [ weak self ] removeFoodID in
                self?.reloadShoppingList()
                self?.deleteFoodOnShoppingList(foodId: removeFoodID, complection: { })
            }
        }
    }
}
