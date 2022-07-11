//
//  ShoppingListViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/20/22.
//
// shoppingList 再次確認有無問題

// bug shoppingList Name fetch 回來

// bug 更換時 沒有的話不能新增

// bug 照片不能新增上去

import UIKit
import BTNavigationDropdownMenu
import LZViewPager
import FirebaseAuth

class ShoppingListViewController: UIViewController, LZViewPagerDelegate, LZViewPagerDataSource {
    
    private var tapButton = UIButton()
    
    var tabIndex: Int?
    
    var cate: [String?] = []
    
    var foodManager = FoodManager.shared
    
    var shopDidSelectDifferentRef: Int?
    
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
    
    var onPublished: (() -> Void)?
    
    var menuView: BTNavigationDropdownMenu!
    
    private lazy var createVC = CreatePersonViewController()
    
    private var viewPager =  LZViewPager()
    
    private lazy var wishListVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "wishListVC") as? WishListViewController

    private lazy var inshoppingListVC = UIStoryboard(name: "Main", bundle: nil)
        .instantiateViewController(withIdentifier: "inshoppingListVC") as? InshoppingViewController
    
    private lazy var containerView: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewPagerProperties()
        
        //        shoppingList.collectionViewLayout = UICollectionViewLayout()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                print( "\(String(describing: user?.uid))" )
                return
            } else {
                self.present( LoginViewController(), animated: true )
            }
        }
        self.fetchAllCate { [weak self] cate in
            self?.cate = cate
        }
        
        // fetch refrige fetch 購買清單  // fetch 食物 -> 分類
        // w for fix error 應該先fetch 在回來抓
        self.fetchAllShoppingListInSingleRefrige { [weak self] shoppingLists in
            self?.shoppingLists = shoppingLists
            if shoppingLists.isEmpty {
                self?.present(self?.createVC ?? CreatePersonViewController(), animated: true)
            }
            self?.fetchAllShoppingListInfoInsingleRefrige(
                shopingLists: shoppingLists,
                completion: { [weak self] totalShopListInfo in
                
                self?.setDropdown(shoppingLists: totalShopListInfo)
                })
            self?.setDropdown(shoppingLists: shoppingLists)
            // change name Bugs
            
//            shoppingListNowID = "dwdwdwd" // fetch initial
/*            self?.fetchAllFoodInfoInSingleShopList { [weak self] foodssInfo in
                self?.fetAllFood(foodID: foodssInfo, completion: { allfoodInfo in
                    guard let cates = self?.cate else { return }
                    self?.resetRefrigeFood()
                    self?.cateFilter(allFood: allfoodInfo, cates: cates)
                    DispatchQueue.main.async {
                        // lottie 消失
                        
                        //                            self?.shoppingList.reloadData()
                        //                           semaphore.signal()
                    }
                })
            }*/
        }
    }
    
    // MARK: - Main VC
    func viewPagerProperties() {
        view.addSubview(viewPager)
        
        viewPager.snp.makeConstraints { make in
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.top.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        viewPager.delegate = self
        viewPager.dataSource = self
        viewPager.hostController = self
        
        guard let wishListVC = wishListVC else { return }
        guard let inshoppingListVC = inshoppingListVC else { return }
        
        wishListVC.title = "願望清單"
        inshoppingListVC.title = "採購中"
        
        containerView = [wishListVC, inshoppingListVC]
        viewPager.reload()
    }
    
    func numberOfItems() -> Int {
        containerView.count
    }
    
    func controller(at index: Int) -> UIViewController {
        containerView[index]
    }
    
    func button(at index: Int) -> UIButton {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "PingFang TC", size: 16)
        button.setTitleColor(.FoodyFlow.lightGray, for: .normal)
        button.setTitleColor(.FoodyFlow.black, for: .selected)
        button.backgroundColor = UIColor.FoodyFlow.white
        
        return button
    }
    
    func backgroundColorForHeader() -> UIColor {
        
        return UIColor.FoodyFlow.lightOrange
    }
    
    func colorForIndicator(at index: Int) -> UIColor {
        
        return UIColor.FoodyFlow.darkOrange
    }
    
    func heightForIndicator(at index: Int) -> CGFloat {
        return CGFloat(50.0)
    }
    
    func setDropdown(shoppingLists: [String?]) {
        
        var items: [String] = []
        
        for shoppingList in shoppingLists {
            items.append(shoppingList ?? "")}
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = UIColor.FoodyFlow.darkOrange
        self.navigationController?.navigationBar.barTintColor = UIColor.FoodyFlow.darkOrange
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // menuView change
        
        menuView = BTNavigationDropdownMenu(
            navigationController: self.navigationController,
            containerView: self.navigationController!.view,
            title: BTTitle.index(0), items: items)
        
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = UIColor.FoodyFlow.darkOrange
        menuView.selectedCellTextLabelColor = UIColor.FoodyFlow.lightGray
        menuView.cellSelectionColor = UIColor.FoodyFlow.darkOrange
        menuView.shouldKeepSelectedCellColor = true
        menuView.cellTextLabelColor = UIColor.FoodyFlow.white
        menuView.cellTextLabelFont = UIFont(name: "PingFang TC", size: 16)
        menuView.cellTextLabelAlignment = .left // .Center // .Right // .Left
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.5
        menuView.maskBackgroundOpacity = 0.3
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> Void in
            print("Did select item at index: \(indexPath)")
        }
        
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> Void in
            print("Did select item at index: \(indexPath)")
            self.shopDidSelectDifferentRef = indexPath
            self.wishListVC?.shopDidSelectDifferentRef = indexPath
           // self.inshoppingListVC?.shopDidSelectDifferentRef = indexPath
        }
        
        self.navigationItem.titleView = menuView
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
    
    func cateFilter( allFood: [FoodInfo], cates: [String?] ) {
        for foodInfo in allFood {
            for cate in cates {
                guard let foodCategory = foodInfo.foodCategory else { return }
                if foodCategory == cate! && cate! == "肉類" {
                    self.meatsInfo.append(foodInfo) } else if
                    foodCategory == cate! && cate! == "豆類" {
                    self.beansInfo.append(foodInfo) } else if
                    foodCategory == cate! && cate! == "雞蛋類" {
                    self.eggsInfo.append(foodInfo) } else if
                    foodCategory == cate! && cate! == "青菜類" {
                    self.vegsInfo.append(foodInfo) } else if
                    foodCategory == cate! && cate! == "醃製類" {
                    self.picklesInfo.append(foodInfo) } else if
                    foodCategory == cate! && cate! == "水果類" {
                    self.fruitsInfo.append(foodInfo) } else if
                    foodCategory == cate! && cate! == "魚類" {
                    self.fishesInfo.append(foodInfo) } else if
                    foodCategory == cate! && cate! == "海鮮類" {
                    self.seafoodsInfo.append(foodInfo) } else if
                    foodCategory == cate! && cate! == "飲料類" {
                    self.beveragesInfo.append(foodInfo) } else if
                    foodCategory == cate! && cate! == "調味料類" {
                    self.seasonsInfo.append(foodInfo) } else if
                    foodCategory == cate! && cate! == "其他" {
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
        refrigeNowID = refrigeNow?.id // rename
        
        // 此處判斷shoppingList 是否是空的 如果是空的創建shoppingList
        
        ShoppingListManager.shared.fetchAllShoppingListIDInSingleRefrige(completion: { result  in
            switch result {
            case .success(let shoppingLists):
                completion(shoppingLists)
            case .failure:
                print("fetch shoppingListID error")
                
            }})
    }
    
    func fetchAllShoppingListInfoInsingleRefrige( shopingLists:[String?],  completion: @escaping([String?]) -> Void) {
        
        var shoppingListsTitle: [String?] = []
        ShoppingListManager.shared.fetchALLShopListInfoInSingleRefrige(shopplingLists: shopingLists) { result in
            switch result {
            case .success(let shoppingList):
                shoppingListsTitle.append(shoppingList?.title ?? "我的購買清單")
                // change shoppingList 判別數量相同
                if ((self.shoppingLists[0]?.count) != nil) {
                    completion(shoppingListsTitle)}
                else { print("not finish ") }
            case .failure:
                print("fetch shoppingListInfo error")
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
    
    func finishShoppingToRefrige(foodId: String, complection: @escaping() -> Void) {
        
        //        guard var refrigeNow = refrigeNow else { return }
        //        guard let foodId = foodId else { return }  // bugs
        
        refrigeNow!.foodID.append(foodId) // global
        RefrigeManager.shared.publishFoodOnRefrige(refrige: refrigeNow!) { result in
            switch result {
            case .success:
                // change food status
                self.foodManager.changeFoodStatus(foodId: foodId, foodStatus: 3) {
                    //                    self.onPublished?()
                    RefrigeManager.shared.fetchSingleRefrigeInfo(refrige: refrigeNow!) { result in
                        switch result {
                        case .success(let refrigeInfo):
                            refrigeNow = refrigeInfo
                            // 抓 fetch shoppingList foodInfo
                            // remove foodID
                            // d
                            
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
    
    // MARK: - recurrect
    func deleteFoodOnShoppingList(foodId: String, complection: @escaping() -> Void) {
        
        let semaphore = DispatchSemaphore(value: 0)
        
        DispatchQueue.global().async {
            /*
             self.fetchAllFoodInfoInSingleShopList { foodsInfos in
             Mark:
             //                var newshoppingList: ShoppingList = ShoppingList(
             //                    foodID: [""])
             //                                var newshoppingList = foodsInfos.filter { $0 != foodId }
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
             //                            self.shoppingList.reloadData()
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
             }*/
        }
    }
}

// MARK: - Delegate
//    return CGSize(width: (screenSize - 16*2 - 15)/2, height: (screenSize - 16*2 - 15)/2 * 1.34)

//      func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//          print("row: \(indexPath.row)")
//      }
// delete or change to Refrige
