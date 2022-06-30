//
//  WishListViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/26/22.
//

import UIKit
import SnapKit

class WishListViewController: UIViewController {
    
    private var tapButton = UIButton()
    
    var tabIndex: Int?
    
    var cate: [String?] = []
    
    var foodManager = FoodManager.shared
    
    // 狀態有改 reload filter 之後的篩選
    
    var shoppingLists: [String?] = []
    
    var foodsInShoppingList: [String?] = []
    
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
    
    var onPublished: (()->())?
    
    @IBOutlet weak var wishList: UICollectionView!
//    {didSet{shoppingList.reloadData()}}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wishList.delegate = self
        wishList.dataSource = self
        wishList.addSubview(tapButton)
        setUI()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        wishList.layoutIfNeeded()
        tapButton.layer.cornerRadius = (tapButton.frame.height)/2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let semaphore = DispatchSemaphore(value: 0)
        
//        DispatchQueue.global().async {
            self.fetchAllCate { [weak self] cate in
                self?.cate = cate
            }
            
            // fetch refrige fetch 購買清單  // fetch 食物 -> 分類
            // w for fix error 應該先fetch 在回來抓
            self.fetchAllShoppingListInSingleRefrige { [weak self] shoppingLists in
                self?.shoppingLists = shoppingLists
                shoppingListNowID = "dwdwdwd" // fetch initial
                self?.fetchAllFoodInfoInSingleShopList { [weak self] foodssInfo in
                    self?.fetAllFood(foodID: foodssInfo, completion: { allfoodInfo in
                        guard let cates = self?.cate else { return }
                        self?.resetRefrigeFood()
                        self?.cateFilter(allFood: allfoodInfo, cates: cates)
                        DispatchQueue.main.async {
                            // lottie 消失
                            
                            self?.wishList.reloadData()
  //                          semaphore.signal()
                        }
                    })
                }
            }
            
  //          semaphore.wait()
            
//        }
    }
    
    func setUI() {

        tapButton.translatesAutoresizingMaskIntoConstraints = false
        tapButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        tapButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        tapButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        tapButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        tapButton.layer.backgroundColor = UIColor.FoodyFlow.darkOrange.cgColor
        tapButton.setImage(UIImage(systemName: "plus"), for: .normal)
        tapButton.imageView?.tintColor = UIColor.FoodyFlow.white
        tapButton.addTarget(self, action: #selector(addNewFood), for: .touchUpInside)
    }
    @objc func addNewFood() {
        
        let shoppingVC = ShoppingListProductDetailViewController(
            nibName: "ShoppingListProductDetailViewController",
            bundle: nil)
        
        shoppingVC.shoppingList.foodID = foodsInShoppingList
//        shoppingVC.refrige = refrige[0]
        self.navigationController!.pushViewController(shoppingVC, animated: true)

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
                    guard let foodCategory = foodInfo.foodCategory else { return }
                    if foodCategory == cate! && cate! == "肉類"
                    { self.meatsInfo.append(foodInfo) }
                     else if foodCategory == cate! && cate! == "豆類"
                    { self.beansInfo.append(foodInfo) }
                    else if foodCategory == cate! && cate! == "雞蛋類"
                    { self.eggsInfo.append(foodInfo) }
                    else if foodCategory == cate! && cate! == "青菜類"
                    { self.vegsInfo.append(foodInfo) }
                    else if foodCategory == cate! && cate! == "醃製類"
                    { self.picklesInfo.append(foodInfo) }
                    else if foodCategory == cate! && cate! == "水果類"
                    { self.fruitsInfo.append(foodInfo) }
                    else if foodCategory == cate! && cate! == "魚類"
                    { self.fishesInfo.append(foodInfo) }
                    else if foodCategory == cate! && cate! == "海鮮類"
                    { self.seafoodsInfo.append(foodInfo) }
                    else if foodCategory == cate! && cate! == "飲料類"
                    { self.beveragesInfo.append(foodInfo) }
                    else if foodCategory == cate! && cate! == "調味料類"
                    { self.seasonsInfo.append(foodInfo) }
                    else if foodCategory == cate! && cate! == "其他"
                    { self.othersInfo.append(foodInfo) }
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
    // fetch shoppingList number
    func fetchAllShoppingListInSingleRefrige(completion: @escaping([String?]) -> Void) {
        refrigeNowID = "2" // rename
        ShoppingListManager.shared.fetchAllShoppingListInSingleRefrige { result in
            switch result {
            case .success(let shoppingLists):
                completion(shoppingLists)
            case .failure:
            print("fetch shoppingList error")
                
            }
        }
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
    func fetAllFood(foodID: [String?],completion: @escaping([FoodInfo]) -> Void) {
        self.foodsInfo = []
        foodManager.fetchSpecifyFoodInShopping(foods: foodID, completion: { result in
            switch result {
            case .success(let foodsinfo):
                self.foodsInfo.append(foodsinfo)
                if self.foodsInfo.count == self.foodsInShoppingList.count {completion(self.foodsInfo)}
            else {print("append not finish yet ")}

            case .failure:
                print("fetch shopplinglist food error")
            }
        })
    }
    
    func finishShoppingToRefrige(foodId: String, complection: @escaping() -> Void) {
        
//        guard var refrigeNow = refrigeNow else { return }
//        guard let foodId = foodId else { return }  // bugs
        
        refrigeNow!.foodID.append(foodId) // global
        RefrigeManager.shared.publishFoodOnRefrige(refrige: refrigeNow!) { result in
            switch result {
            case .success:
                // change food status
                self.foodManager.changeFoodStatus(foodId: foodId, foodStatus: 3) {
                    self.deleteFoodOnShoppingList(foodId: foodId) {
                        print("delete okay")
                    }
                    // 抓 fetch shoppingList foodInfo
                    // remove foodID
                                // d
                    
                }
            case .failure:
                print("cannot fetch cate data")
                        }
                    }
                }
    
    func deleteFoodOnShoppingList(foodId: String, complection: @escaping() -> Void) {
        
//        let semaphore = DispatchSemaphore(value: 0)
        
//        DispatchQueue.global().async {
        
        self.fetchAllFoodInfoInSingleShopList { foodsInfos in
            
            var newshoppingList: ShoppingList = ShoppingList(
                foodID: [""])
            
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
                            self.wishList.reloadData()
  //                          semaphore.signal()
                        }
                            
                        }
                    }
                case .failure(let error):
                    print("publishArticle.failure: \(error)")
                }
            }
            
        }
 //           semaphore.wait()
        }
 //   }

}

extension WishListViewController: UICollectionViewDataSource,
                                      UICollectionViewDelegate,
                                      UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cate.count // 食物種類
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "shoppingListCollectionViewCell",
                for: indexPath) as? ShoppingListCollectionViewCell
        guard let cell = cell else { return UICollectionViewCell() }
        cell.layer.backgroundColor = UIColor(red: 1, green: 0.964, blue: 0.929, alpha: 1).cgColor
        cell.layer.cornerRadius = 20
        cell.shoppingItemImage.lkCornerRadius = 20
        switch indexPath.section {
        case 0:
            cell.shoppingName.text = meatsInfo[indexPath.item].foodName
        case 1:
            cell.shoppingName.text = beansInfo[indexPath.item].foodName

        case 2:
            cell.shoppingName.text = eggsInfo[indexPath.item].foodName

        case 3:
            cell.shoppingName.text = vegsInfo[indexPath.item].foodName

        case 4:
            cell.shoppingName.text = picklesInfo[indexPath.item].foodName

        case 5:
            cell.shoppingName.text = fruitsInfo[indexPath.item].foodName

        case 6:
            cell.shoppingName.text = fishesInfo[indexPath.item].foodName

        case 7:
            cell.shoppingName.text = seafoodsInfo[indexPath.item].foodName

        case 8:
            cell.shoppingName.text = beveragesInfo[indexPath.item].foodName

        case 9:
            cell.shoppingName.text = seasonsInfo[indexPath.item].foodName

        case 10:
            cell.shoppingName.text = othersInfo[indexPath.item].foodName

        default:
            cell.shoppingName.text = foodsInfo[indexPath.item].foodName
            
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if let sectionHeader = collectionView.dequeueReusableSupplementaryView (
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
    return CGSize(width: 200, height: 200)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            finishShoppingToRefrige(foodId: meatsInfo[indexPath.item].foodId ?? "2") {
                
            }
        case 1:
            finishShoppingToRefrige(foodId: beansInfo[indexPath.item].foodId ?? "2") {
                print("success to reFirge ")
            }
        case 2:
            finishShoppingToRefrige(foodId: eggsInfo[indexPath.item].foodId ?? "2") {
                print("success to reFirge ")
            }

        case 3:
            finishShoppingToRefrige(foodId: vegsInfo[indexPath.item].foodId ?? "2") {
                print("success to reFirge ")
            }

        case 4:
            finishShoppingToRefrige(foodId: picklesInfo[indexPath.item].foodId ?? "2") {
                print("success to reFirge ")
            }
        case 5:
            finishShoppingToRefrige(foodId: fruitsInfo[indexPath.item].foodId ?? "2") {
                print("success to reFirge ")
            }
//            deleteFoodOnShoppingList(foodId: fruitsInfo[indexPath.item].foodId ?? "2") {
//                print("success to delete " )
//            }
        case 6:
            finishShoppingToRefrige(foodId: fishesInfo[indexPath.item].foodId ?? "2") {
                print("success to reFirge ")
            }
        case 7:
            finishShoppingToRefrige(foodId: seafoodsInfo[indexPath.item].foodId ?? "2") {
                print("success to reFirge ")
            }
        case 8:
            finishShoppingToRefrige(foodId: beveragesInfo[indexPath.item].foodId ?? "2") {
                print("success to reFirge ")
            }

        case 9:
            finishShoppingToRefrige(foodId: seasonsInfo[indexPath.item].foodId ?? "2") {
                print("success to reFirge ")
            }

        case 10:
            finishShoppingToRefrige(foodId: othersInfo[indexPath.item].foodId ?? "2") {
                print("success to reFirge ")
            }

        default:
            print("dd")
        }
    }

}
