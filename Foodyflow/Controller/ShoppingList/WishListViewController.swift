//
//  WishListViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/26/22.
// 狀態有改 reload filter 之後的篩選

import UIKit
import SnapKit
import Kingfisher
import FirebaseAuth

class WishListViewController: UIViewController, ShopButtonPanelDelegate {
    
    private lazy var notiname = Notification.Name("dropDownShopReloadNoti")

    private let wishBtn = ShoppingListBtnPanelView()
    
    var tabIndex: Int?
    
    var cate: [String?] = []
    
    var foodManager = FoodManager.shared
    
    var shoppingLists: [String?] = []
    
    var foodsInShoppingList: [String?] = []
    
    var shopList: ShoppingList?
    
    var shoppingListView = ShoppingListView()
    
    var foodsInfo: [FoodInfo] = []

    var allfoodInfo: [[FoodInfo]] = []
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wishListCollectionView.delegate = self
        wishListCollectionView.dataSource = self
        wishListCollectionView.addSubview(wishBtn)
        setupUI()
        wishBtn.delegate = self

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        wishListCollectionView.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let semaphore = DispatchSemaphore(value: 0)
        
        DispatchQueue.global().async {
            self.fetchAllCate { [weak self] cates in
                self?.cate = cates
                semaphore.signal()
            }
            semaphore.wait()
            self.fetchAllShoppingListInSingleRefrige { [weak self] shoppingLists in
            self?.shoppingLists = shoppingLists
            if shoppingLists.isEmpty { self?.emptyCollectionView() } else {
            shoppingListNowID = self?.shoppingLists[self?.shopDidSelectDifferentRef ?? 0]
                self?.fetchAllFoodInfoInSingleShopList { [weak self] foodssInfo in
                    if foodssInfo.isEmpty { self?.emptyCollectionView() } else {
                        if foodssInfo[0] == "" { self?.emptyCollectionView() } else {
                        self?.wishListCollectionView.backgroundView = nil
                        self?.fetAllFood(foodID: foodssInfo, completion: { allfoodInfo in
                        let wishshopFoodInfo = allfoodInfo.filter { foodinfo in foodinfo.foodStatus == 1 }
                        if  wishshopFoodInfo.isEmpty { self?.emptyCollectionView() }
                        guard let cates = self?.cate else { return }
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
                
        self.fetchAllCate { [weak self] cates in self?.cate = cates }
            
        self.fetchAllShoppingListInSingleRefrige { [weak self] shoppingList in
            self?.shoppingLists = shoppingList
           //  crash point
            shoppingListNowID = self?.shoppingLists[self?.shopDidSelectDifferentRef ?? 0]
//             print("\(shoppingListNowID)")
                self?.fetchAllFoodInfoInSingleShopList { [weak self] foodssInfo in
                    if foodssInfo.isEmpty { self?.emptyCollectionView() } else {
                    if foodssInfo[0] == "" {
                        self?.emptyCollectionView() } else {
                        self?.wishListCollectionView.backgroundView = nil
                        self?.fetAllFood(foodID: foodssInfo, completion: { allfoodInfo in
                        let wishshopFoodInfo = allfoodInfo.filter { foodinfo in
                                    foodinfo.foodStatus == 1 }
                            if  wishshopFoodInfo.isEmpty { self?.emptyCollectionView() }
                            guard let cates = self?.cate else { return }
                            self?.cateFilter(allFood: wishshopFoodInfo, cates: cates)
                            DispatchQueue.main.async {
                                // lottie 消失
                                self?.wishListCollectionView.reloadData()
                            }
                        })}
                    }
                }

        }
    }
    
    private func alertSheet(food: FoodInfo) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "移至購買清單", style: .default, handler: { _ in
            self.foodManager.changeFoodStatus(foodId: foodId, foodStatus: 2) {
                self.reloadWishList()
        
        }
            
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

    func setupUI() {

        wishBtn.translatesAutoresizingMaskIntoConstraints = false
        wishBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        wishBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        wishBtn.layer.backgroundColor = UIColor.FoodyFlow.btnOrange.cgColor
    }
        
    func cateFilter(allFood: [FoodInfo], cates: [String?]) {
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

        for foodInfo in allFood {
            switch foodInfo.foodCategory {
            case Categorytype.meat.rawValue:
                self.meatsInfo.append(foodInfo)
            case Categorytype.beans.rawValue:
                self.beansInfo.append(foodInfo)
            case Categorytype.eggs.rawValue:
                self.eggsInfo.append(foodInfo)
            case Categorytype.vegs.rawValue:
                self.vegsInfo.append(foodInfo)
            case Categorytype.pickles.rawValue:
                self.picklesInfo.append(foodInfo)
            case Categorytype.fruit.rawValue:
                self.fruitsInfo.append(foodInfo)
            case Categorytype.fishes.rawValue:
                self.fishesInfo.append(foodInfo)
            case Categorytype.seafoods.rawValue:
                self.seafoodsInfo.append(foodInfo)
            case Categorytype.beverage.rawValue:
                self.beveragesInfo.append(foodInfo)
            case Categorytype.others.rawValue:
                self.othersInfo.append(foodInfo)
            default:
                break
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
    
    func didTapButtonWithText(_ text: Int) { verifyUser(btn: text) }
    
    private func verifyUser(btn: Int) {
        Auth.auth().addStateDidChangeListener { (_, user) in
            if user != nil {
                
                // create food
                if btn == 1 {
                    
                     // no refrige
                    if refrigeNow?.id == nil {
                        
                        self.whenFrigeIsEmptyAlert()
                        
                    }
                     // no shopList
                    else if self.shoppingLists.isEmpty {
                        self.whenShopListIsEmptyAlert()
                    } else {
                    // create Food
                    let shoppingVC = ShoppingListProductDetailViewController(
                                nibName: "ShoppingListProductDetailViewController",
                                bundle: nil)
                            
                    shoppingVC.shoppingList.foodID = self.foodsInShoppingList
                    ShoppingListManager.shared.fetchShopListInfo(shopplingListID: shoppingListNowID) { [weak self ] result in
                    switch result {
                    case .success(let shopLists):
                    shoppingVC.shoppingList = shopLists ?? ShoppingList(id: "dd", title: "", foodID: [])
                    self?.navigationController!.pushViewController(shoppingVC, animated: true)

                    case .failure:
                        HandleResult.reportFailed.messageHUD
                        
                    } }
                    } } else if btn == 2 {
                    // create shopList
                    if refrigeNow?.id == nil {
                        
                        self.whenFrigeIsEmptyAlert()
                        } else {
                        self.createShoppingList()
                        }}
            } else {
                self.present(LoginViewController(), animated: true)
            }
        }

    }
    
    private func whenFrigeIsEmptyAlert() {
        
        let controller = UIAlertController(title: "尚未有食光冰箱", message: "請先在冰箱頁創立", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
            
        }
        controller.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            
        }
        controller.addAction(okAction)

        present(controller, animated: true, completion: nil)
        
    }
    
    private func whenShopListIsEmptyAlert() {
        
        let controller = UIAlertController(title: "尚未有購物清單", message: "請先創立購物清單", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
            
        }
        controller.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            
        }
        controller.addAction(okAction)

        present(controller, animated: true, completion: nil)
        
    }

    private func createShoppingList() {
        
        let alert = UIAlertController(title: "創建購物清單", message: nil, preferredStyle: .alert)
        
        let createAction = UIAlertAction(title: "建立清單", style: .default) { _ in
            
            guard let refrigeID = refrigeNow?.id else { return }
            
            var createNewShop = ShoppingList.init(id: "", title: "我的購物清單", foodID: [])
            
            self.fillShopListName { createNewShopListName in
                createNewShop.title = createNewShopListName
                
                ShoppingListManager.shared.createShoppingList(shoppingList: &createNewShop, refrigeID: refrigeID) { result in
                    switch result {
                    case .success:
                        NotificationCenter.default.post(name: self.notiname,
                                                        object: nil)
                        
                        DispatchQueue.main.async {
                            self.reloadWishList()
                        }
                        
                        HandleResult.addDataSuccess.messageHUD
                    case .failure:
                        HandleResult.addDataFailed.messageHUD
                    }
                }
        
            }
        }
        alert.addAction(createAction)
        
        let falseAction = UIAlertAction(title: "取消", style: .cancel)
        
        alert.addAction(falseAction)
        
        alert.show(animated: true, vibrate: false, completion: nil)
                
    }
    
    private func fillShopListName(completion: @escaping (String) -> Void) {
        let alertVC = UIAlertController(title: "請填寫你購物清單的名字", message: "填寫你想紀錄的清單", preferredStyle: .alert)
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
                
        refrigeNow!.foodID.append(foodId) // global
        RefrigeManager.shared.publishFoodOnRefrige(refrige: refrigeNow!) { result in
            switch result {
            case .success:
                // change food status
                self.foodManager.changeFoodStatus(foodId: foodId, foodStatus: 3) {
                    self.deleteFoodOnShoppingList(foodId: foodId) {
                        print("delete okay")
                    }                    
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
                id: "", title: "", foodID: [""])
            
            newshoppingList.foodID = foodsInfos.filter { $0 != foodId }
            self.shoppingLists = newshoppingList.foodID

            ShoppingListManager.shared.postFoodOnShoppingList(shoppingList: &newshoppingList) { result in
                switch result {
                case .success:
                    self.fetchAllFoodInfoInSingleShopList { [weak self] foodssInfo in
                        if foodssInfo.isEmpty { self?.emptyCollectionView() } else {
                            if foodssInfo[0] == "" { self?.emptyCollectionView() } else {
                            self?.wishListCollectionView.backgroundView = nil
                            self?.fetAllFood(foodID: foodssInfo, completion: { allfoodInfo in
                                let wishshopFoodInfo = allfoodInfo.filter { foodinfo in
                                        foodinfo.foodStatus == 1 }
                                if  wishshopFoodInfo.isEmpty { self?.emptyCollectionView() }
                                guard let cates = self?.cate else { return }
                                self?.cateFilter(allFood: wishshopFoodInfo, cates: cates)
                                DispatchQueue.main.async {
                                    // lottie 消失
                                    self?.wishListCollectionView.reloadData()
                                }
                            })}
                        }
                    }
                case .failure(let error):
                    print("publishArticle.failure: \(error)")
                }
            }
            
        }
        }
    
    // MARK: - empty collectionview
    
    func emptyCollectionView() { // lottie 消失
        self.cate = []
        DispatchQueue.main.async {
            self.wishListCollectionView.reloadData()
            self.wishListCollectionView.backgroundView = self.shoppingListView }
    }
    
    // MARK: - create ShopList
    
    func createShopList(newshopList: ShoppingList, refrige: Refrige, completion: @escaping() -> Void) {
        
        var newshopList = newshopList
        ShoppingListManager.shared.createShoppingList(shoppingList: &newshopList, refrigeID: refrige.id) { result in
            switch result {
            case .success:
                HandleResult.addDataSuccess.messageHUD
            case .failure:
                HandleResult.addDataFailed.messageHUD
            }
        }
    }
    
    }

extension WishListViewController: UICollectionViewDataSource,
                                      UICollectionViewDelegate,
                                      UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cate.count
    }
     // change enum
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
              return UICollectionViewCell()
          }

        switch section {
        case .meat:
            
            cell.shoppingName.text = meatsInfo[indexPath.item].foodName
            cell.shoppingItemImage.kf.setImage(with: URL( string: meatsInfo[indexPath.item].foodImages ?? "" ))
            cell.shoppingBrand.text = meatsInfo[indexPath.item].foodBrand
            cell.shoppingLocation.text = meatsInfo[indexPath.item].foodPurchasePlace
            cell.shoppingWeight.isHidden = true
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
            sectionHeader.sectionHeaderlabel.text = self.cate[indexPath.section]
            sectionHeader.sectionHeaderlabel.font = UIFont(name: "PingFang TC", size: 20)
            return sectionHeader
        }
        return UICollectionReusableView()
    }

    private func collectionView(_ collectionView: UICollectionView,
                                layout collectionViewLayout: UICollectionViewLayout,
                                sizeForItemAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20.0, left: 16.0, bottom: 10.0, right: 16.0) }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 200, height: 200) }

    // MARK: - single tap edit
    // MARK: - delete food or send to shoppingList to long gestture
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let section = CategoryType(rawValue: indexPath.section) else { assertionFailure(); return }
        switch section {
        case .meat:
            alertSheet(food: meatsInfo[indexPath.item])
        case .beans:
            alertSheet(food: beansInfo[indexPath.item])
        case .eggs:
            alertSheet(food: eggsInfo[indexPath.item])
        case .vegs:
            alertSheet(food: vegsInfo[indexPath.item])
        case .pickles:
            alertSheet(food: picklesInfo[indexPath.item])
        case .fruit:
            alertSheet(food: fruitsInfo[indexPath.item])
        case .fishes:
            alertSheet(food: fishesInfo[indexPath.item])
        case .seafoods:
            alertSheet(food: seafoodsInfo[indexPath.item])
        case .beverage:
            alertSheet(food: beveragesInfo[indexPath.item])
        case .seasons:
            alertSheet(food: seasonsInfo[indexPath.item])
        case .others:
            alertSheet(food: othersInfo[indexPath.item])
        }
    }
}
