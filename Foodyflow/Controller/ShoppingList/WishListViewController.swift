//
//  WishListViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/26/22.
//

import UIKit
import SnapKit
import Kingfisher

// Login 跟 會擋到 

class WishListViewController: UIViewController {
    
    private lazy var tapButton = UIButton()
    
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
    
    var onPublished: ( () -> Void)?
    
    var shopDidSelectDifferentRef: Int? { didSet { reloadWishList() } }
    
    @IBOutlet weak var wishListCollectionView: UICollectionView!

    //    {didSet{shoppingList.reloadData()}}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wishListCollectionView.delegate = self
        wishListCollectionView.dataSource = self
        wishListCollectionView.addSubview(tapButton)
        setUI()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        wishListCollectionView.layoutIfNeeded()
        tapButton.layer.cornerRadius = (tapButton.frame.height)/2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let semaphore = DispatchSemaphore(value: 0)
        
        DispatchQueue.global().async {
            self.fetchAllCate { [weak self] cate in
                self?.cate = cate
            }
            
            // fetch refrige fetch 購買清單  // fetch 食物 -> 分類
            // w for fix error 應該先fetch 在回來抓
            self.fetchAllShoppingListInSingleRefrige { [weak self] shoppingLists in
            self?.shoppingLists = shoppingLists
            if shoppingLists.isEmpty {
                    DispatchQueue.main.async {
                        self?.cate = []
                        self?.wishListCollectionView.backgroundView = SearchPlaceholderView()
                        self?.wishListCollectionView.reloadData()
                        self?.present(CreatePersonViewController(), animated: true) }} else {
            shoppingListNowID = self?.shoppingLists[self?.shopDidSelectDifferentRef ?? 0]
                self?.fetchAllFoodInfoInSingleShopList { [weak self] foodssInfo in
                    if foodssInfo.isEmpty {
                        self?.wishListCollectionView.backgroundView = SearchPlaceholderView()
                    } else {
                    if foodssInfo[0] == "" {
                        self?.wishListCollectionView.backgroundView = SearchPlaceholderView() } else {
                        
                        self?.wishListCollectionView.backgroundView = nil
                        self?.fetAllFood(foodID: foodssInfo, completion: { allfoodInfo in
                        var wishshopFoodInfo = allfoodInfo.filter { foodinfo in
                                foodinfo.foodStatus == 1 }
                        guard let cates = self?.cate else { return }
                        self?.resetRefrigeFood()
                        self?.cateFilter(allFood: wishshopFoodInfo, cates: cates)
                        DispatchQueue.main.async {
                            // lottie 消失
                            self?.wishListCollectionView.reloadData()
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
    
    private func reloadWishList() {
        
        HandleResult.readData.messageHUD
        
        self.fetchAllCate { [weak self] cate in
            self?.cate = cate
        }
            
            self.resetRefrigeFood()
        shoppingListNowID = self.shoppingLists[shopDidSelectDifferentRef ?? 0]
            self.fetchAllFoodInfoInSingleShopList { [weak self] foodssInfo in
                if foodssInfo.isEmpty {
                    self?.wishListCollectionView.backgroundView = SearchPlaceholderView() } else {
                if foodssInfo[0] == "" {
                    DispatchQueue.main.async {
                        self?.cate = []
                        // lottie 消失
                        self?.wishListCollectionView.reloadData()
                        self?.wishListCollectionView.backgroundView = SearchPlaceholderView() } } else {
                    self?.wishListCollectionView.backgroundView = nil
                    self?.fetAllFood(foodID: foodssInfo, completion: { allfoodInfo in
                    var wishshopFoodInfo = allfoodInfo.filter { foodinfo in
                                foodinfo.foodStatus == 1 }
                        guard let cates = self?.cate else { return }
                        self?.resetRefrigeFood()
                        self?.cateFilter(allFood: wishshopFoodInfo, cates: cates)
                        DispatchQueue.main.async {
                            // lottie 消失
                            self?.wishListCollectionView.reloadData()
                        }
                    })}
                }
            }
    }
    
    private func alertSheet(food: FoodInfo) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "移至購買清單", style: .default, handler: { _ in
            self.foodManager.changeFoodStatus(foodId: foodId, foodStatus: 2) {
                print("finish") }
            
        }))
        alert.addAction(UIAlertAction(title: "編輯\(food.foodName!)", style: .default, handler: { _ in
            
            let shoppingVC = ShoppingListProductDetailViewController(
                nibName: "ShoppingListProductDetailViewController",
                bundle: nil)
            
            shoppingVC.shoppingList.foodID = self.foodsInShoppingList
            
            // MARK: - 邏輯在修改
            
            shoppingVC.foodInfo = food
            
    //        shoppingVC.refrige = refrige[0]
            self.navigationController!.pushViewController(shoppingVC, animated: true)

//            self.foodManager.publishFood(food: &<#T##FoodInfo#>, completion: <#T##(Result<String, Error>) -> Void#>)
                print("User click Edit button")}))

        alert.addAction(UIAlertAction(title: "刪除\(food.foodName!)", style: .destructive, handler: { _ in
            
            self.foodManager.deleteFood(foodId: food.foodId) { error in
                    print("\(error)")}
            self.deleteFoodOnShoppingList(foodId: food.foodId ?? "") {
                print("success")}
            print("User click Delete button")}))
            
        alert.addAction(UIAlertAction(title: "返回", style: .cancel, handler: { _ in
                print("User click Dismiss button")}))
        self.present(alert, animated: true, completion: {
            print("completion block") })
        
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
                    if foodCategory == cate! && cate! == "肉類"{ self.meatsInfo.append(foodInfo) } else if
                        foodCategory == cate! && cate! == "豆類"{
                        self.beansInfo.append(foodInfo) } else if
                        foodCategory == cate! && cate! == "雞蛋類"{
                        self.eggsInfo.append(foodInfo) } else if
                        foodCategory == cate! && cate! == "青菜類"{
                        self.vegsInfo.append(foodInfo) } else if
                        foodCategory == cate! && cate! == "醃製類"{
                        self.picklesInfo.append(foodInfo) } else if
                        foodCategory == cate! && cate! == "水果類"{
                        self.fruitsInfo.append(foodInfo) } else if
                        foodCategory == cate! && cate! == "魚類"{
                        self.fishesInfo.append(foodInfo) } else if
                        foodCategory == cate! && cate! == "海鮮類"{
                        self.seafoodsInfo.append(foodInfo) } else if
                        foodCategory == cate! && cate! == "飲料類"{
                        self.beveragesInfo.append(foodInfo) } else if
                        foodCategory == cate! && cate! == "調味料類"{
                        self.seasonsInfo.append(foodInfo) } else if
                        foodCategory == cate! && cate! == "其他"{
                        self.othersInfo.append(foodInfo) }}
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
     //   refrigeNowID = "2" // rename  // 邏輯修改
        ShoppingListManager.shared.fetchAllShoppingListIDInSingleRefrige { result in
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
    
    // MARK: - finishShop to Refrige
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
    
    // MARK: - deleteFood
    func deleteFoodOnShoppingList(foodId: String, complection: @escaping() -> Void) {
        
        self.fetchAllFoodInfoInSingleShopList { foodsInfos in
            
            var newshoppingList: ShoppingList = ShoppingList(
                title: "", foodID: [""])
            
            newshoppingList.foodID = foodsInfos.filter { $0 != foodId }
            self.shoppingLists = newshoppingList.foodID

            ShoppingListManager.shared.postFoodOnShoppingList(shoppingList: &newshoppingList) { result in
                switch result {
                case .success:
                    self.fetchAllFoodInfoInSingleShopList { [weak self] foodssInfo in
                        if foodssInfo.isEmpty {
                            self?.cate = []
                            self?.wishListCollectionView.reloadData()
                            self?.wishListCollectionView.backgroundView = SearchPlaceholderView() }
                        else {
                        if foodssInfo[0] == "" {
                            DispatchQueue.main.async {
                                self?.cate = []
                                // lottie 消失
                                self?.wishListCollectionView.reloadData()
                                self?.wishListCollectionView.backgroundView = SearchPlaceholderView() } } else {
                            self?.wishListCollectionView.backgroundView = nil
                            self?.fetAllFood(foodID: foodssInfo, completion: { allfoodInfo in
                                var wishshopFoodInfo = allfoodInfo.filter { foodinfo in
                                        foodinfo.foodStatus == 1 }
                                guard let cates = self?.cate else { return }
                                self?.resetRefrigeFood()
                                self?.cateFilter(allFood: wishshopFoodInfo, cates: cates)
                                DispatchQueue.main.async {
                                    // lottie 消失
                                    self?.wishListCollectionView.reloadData()
                                }
                            })}
                        }
                    }

                 /*   self.fetAllFood(foodID: self.shoppingLists) { allfoodInfo in
                        if allfoodInfo.isEmpty {
                            self.cate = []
                            self.wishListCollectionView.backgroundView = SearchPlaceholderView()
                            self.wishListCollectionView.reloadData()
                        }
                        else{
                            
                        self.resetRefrigeFood()
                        if let cates = self.cate as? [String] {
                        self.cateFilter(allFood: allfoodInfo, cates: cates)
                        DispatchQueue.main.async {
                            // lottie 消失
                            self.wishListCollectionView.reloadData()
  //                          semaphore.signal()
                        }
                            
                        }
                        }}*/
                case .failure(let error):
                    print("publishArticle.failure: \(error)")
                }
            }
            
        }
        }
    }

extension WishListViewController: UICollectionViewDataSource,
                                      UICollectionViewDelegate,
                                      UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cate.count}
    
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
        switch indexPath.section {
        case 0:
            cell.shoppingName.text = meatsInfo[indexPath.item].foodName
                cell.shoppingItemImage.kf.setImage(with: URL( string: meatsInfo[indexPath.item].foodImages ?? "" ))
            cell.shoppingBrand.text = meatsInfo[indexPath.item].foodBrand
            cell.shoppingLocation.text = meatsInfo[indexPath.item].foodPurchasePlace
            cell.shoppingWeight.isHidden = true  // meatsInfo[indexPath.item].foodWeightAmount
        case 1:
            cell.shoppingName.text = beansInfo[indexPath.item].foodName

                cell.shoppingItemImage.kf.setImage(with: URL( string: beansInfo[indexPath.item].foodImages ?? "" ))
            cell.shoppingBrand.text = beansInfo[indexPath.item].foodBrand
            cell.shoppingLocation.text = beansInfo[indexPath.item].foodPurchasePlace
            cell.shoppingWeight.isHidden = true
         //   cell.shoppingItemImage

        case 2:
            cell.shoppingName.text = eggsInfo[indexPath.item].foodName
            
                cell.shoppingItemImage.kf.setImage(with: URL( string: eggsInfo[indexPath.item].foodImages ?? "" ))
            cell.shoppingBrand.text = eggsInfo[indexPath.item].foodBrand
            cell.shoppingLocation.text = eggsInfo[indexPath.item].foodPurchasePlace
            cell.shoppingWeight.isHidden = true
         //   cell.shoppingItemImage
        case 3:
            cell.shoppingName.text = vegsInfo[indexPath.item].foodName

                cell.shoppingItemImage.kf.setImage(with: URL( string: vegsInfo[indexPath.item].foodImages ?? "" ))
            cell.shoppingBrand.text = vegsInfo[indexPath.item].foodBrand
            cell.shoppingLocation.text = vegsInfo[indexPath.item].foodPurchasePlace
            cell.shoppingWeight.isHidden = true
        case 4:
            cell.shoppingName.text = picklesInfo[indexPath.item].foodName

                cell.shoppingItemImage.kf.setImage(with: URL( string: picklesInfo[indexPath.item].foodImages ?? "" ))
            cell.shoppingBrand.text = picklesInfo[indexPath.item].foodBrand
            cell.shoppingLocation.text = picklesInfo[indexPath.item].foodPurchasePlace
            cell.shoppingWeight.isHidden = true
        case 5:
            cell.shoppingName.text = fruitsInfo[indexPath.item].foodName

                cell.shoppingItemImage.kf.setImage(with: URL( string: fruitsInfo[indexPath.item].foodImages ?? "" ))
            cell.shoppingBrand.text = fruitsInfo[indexPath.item].foodBrand
            cell.shoppingLocation.text = fruitsInfo[indexPath.item].foodPurchasePlace
            cell.shoppingWeight.isHidden = true
        case 6:
            cell.shoppingName.text = fishesInfo[indexPath.item].foodName

                cell.shoppingItemImage.kf.setImage(with: URL( string: fishesInfo[indexPath.item].foodImages ?? "" ))
            cell.shoppingBrand.text = fishesInfo[indexPath.item].foodBrand
            cell.shoppingLocation.text = fishesInfo[indexPath.item].foodPurchasePlace
            cell.shoppingWeight.isHidden = true
        case 7:
            cell.shoppingName.text = seafoodsInfo[indexPath.item].foodName

                cell.shoppingItemImage.kf.setImage(with: URL( string: seafoodsInfo[indexPath.item].foodImages ?? "" ))
            cell.shoppingBrand.text = seafoodsInfo[indexPath.item].foodBrand
            cell.shoppingLocation.text = seafoodsInfo[indexPath.item].foodPurchasePlace
            cell.shoppingWeight.isHidden = true
        case 8:
            cell.shoppingName.text = beveragesInfo[indexPath.item].foodName

                cell.shoppingItemImage.kf.setImage(with: URL( string: beveragesInfo[indexPath.item].foodImages ?? "" ))
            cell.shoppingBrand.text = beveragesInfo[indexPath.item].foodBrand
            cell.shoppingLocation.text = beveragesInfo[indexPath.item].foodPurchasePlace
            cell.shoppingWeight.isHidden = true
        case 9:
            cell.shoppingName.text = seasonsInfo[indexPath.item].foodName

                cell.shoppingItemImage.kf.setImage(with: URL( string: seasonsInfo[indexPath.item].foodImages ?? "" ))
            cell.shoppingBrand.text = seasonsInfo[indexPath.item].foodBrand
            cell.shoppingLocation.text = seasonsInfo[indexPath.item].foodPurchasePlace
            cell.shoppingWeight.isHidden = true
        case 10:
            cell.shoppingName.text = othersInfo[indexPath.item].foodName
                cell.shoppingItemImage.kf.setImage(with: URL( string: othersInfo[indexPath.item].foodImages ?? "" ))
            cell.shoppingBrand.text = othersInfo[indexPath.item].foodBrand
            cell.shoppingLocation.text = othersInfo[indexPath.item].foodPurchasePlace
            cell.shoppingWeight.isHidden = true
        default:
            cell.shoppingName.text = foodsInfo[indexPath.item].foodName
            
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

    // MARK: - single tap edit
    // MARK: - delete food or send to shoppingList to long gestture
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            alertSheet(food: meatsInfo[indexPath.item])
           // finishShoppingToRefrige(foodId: meatsInfo[indexPath.item].foodId ?? "2") {
//            }
        case 1:
            alertSheet(food: beansInfo[indexPath.item])
//            finishShoppingToRefrige(foodId: beansInfo[indexPath.item].foodId ?? "2") {
//                print("success to reFirge ")
//            }
        case 2:
            alertSheet(food: eggsInfo[indexPath.item])
//            finishShoppingToRefrige(foodId: eggsInfo[indexPath.item].foodId ?? "2") {
//                print("success to reFirge ")
//            }

        case 3:
            alertSheet(food: vegsInfo[indexPath.item])
  //          finishShoppingToRefrige(foodId: vegsInfo[indexPath.item].foodId ?? "2") {
 //               print("success to reFirge ")
 //           }

        case 4:
            alertSheet(food: picklesInfo[indexPath.item])

//            finishShoppingToRefrige(foodId: picklesInfo[indexPath.item].foodId ?? "2") {
//                print("success to reFirge ")
//            }
        case 5:
            alertSheet(food: fruitsInfo[indexPath.item])
//            finishShoppingToRefrige(foodId: fruitsInfo[indexPath.item].foodId ?? "2") {
//                print("success to reFirge ")
//            }
//            deleteFoodOnShoppingList(foodId: fruitsInfo[indexPath.item].foodId ?? "2") {
//                print("success to delete " )
//            }
        case 6:
            alertSheet(food: fishesInfo[indexPath.item])
        //    finishShoppingToRefrige(foodId: fishesInfo[indexPath.item].foodId ?? "2") {
        //        print("success to reFirge ")
        //    }
        case 7:
            alertSheet(food: seafoodsInfo[indexPath.item])
       //     finishShoppingToRefrige(foodId: seafoodsInfo[indexPath.item].foodId ?? "2") {
       //         print("success to reFirge ")
       //     }
        case 8:
           // finishShoppingToRefrige(foodId: beveragesInfo[indexPath.item].foodId ?? "2") {
            //    print("success to reFirge ")
           // }
            alertSheet(food: beveragesInfo[indexPath.item])

        case 9:
            alertSheet(food: seasonsInfo[indexPath.item])
       //     finishShoppingToRefrige(foodId: seasonsInfo[indexPath.item].foodId ?? "2") {
       //         print("success to reFirge ")
       //     }

        case 10:
            alertSheet(food: othersInfo[indexPath.item])
        //    finishShoppingToRefrige(foodId: othersInfo[indexPath.item].foodId ?? "2") {
        //        print("success to reFirge ")
        //    }

        default:
            print("dd")
        }
    }
}
