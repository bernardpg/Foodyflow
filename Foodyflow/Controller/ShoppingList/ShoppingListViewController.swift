//
//  ShoppingListViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/20/22.
//

import UIKit
import BTNavigationDropdownMenu
import LZViewPager

class ShoppingListViewController: UIViewController, LZViewPagerDelegate, LZViewPagerDataSource {
    
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
    
    var onPublished: (() -> Void)?
    
    var menuView: BTNavigationDropdownMenu!
        
    private var viewPager =  LZViewPager()
    
    private lazy var containerView: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setDropdown()
        viewPagerProperties()
//        shoppingList.collectionViewLayout = UICollectionViewLayout()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
                shoppingListNowID = "dwdwdwd" // fetch initial
                self?.fetchAllFoodInfoInSingleShopList { [weak self] foodssInfo in
                    self?.fetAllFood(foodID: foodssInfo, completion: { allfoodInfo in
                        guard let cates = self?.cate else { return }
                        self?.resetRefrigeFood()
                        self?.cateFilter(allFood: allfoodInfo, cates: cates)
                        DispatchQueue.main.async {
                            // lottie 消失
                            
//                            self?.shoppingList.reloadData()
                            semaphore.signal()
                        }
                    })
                }
            }
            
            semaphore.wait()
            
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
        
        let wishListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wishListVC") as? WishListViewController
                
        let inshoppingListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inshoppingListVC") as? InshoppingViewController
        
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
        //button.setTitleColor(UIColor.black, for: .normal)
        button.setTitleColor(UIColor.B1, for: .normal)
        button.titleLabel?.font = UIFont(name: "PingFang TC", size: 16)
        //button.backgroundColor = .black
        return button
    }
    
    func backgroundColorForHeader() -> UIColor {
        
        return UIColor.hexStringToUIColor(hex: "F4943A")
    }
    
    func colorForIndicator(at index: Int) -> UIColor {
        
        return UIColor.hexStringToUIColor(hex: "FCE3CB")
    }
    
    // wait for change 
    func setDropdown() {
        let items = ["購買清單", "Latest", "Trending", "Nearest", "Top Picks"]
      //  self.selectedCellLabel.text = items.first
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = UIColor.hexStringToUIColor(hex: "F4943A")
        self.navigationController?.navigationBar.barTintColor = UIColor.hexStringToUIColor(hex: "F4943A")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        menuView = BTNavigationDropdownMenu(
            navigationController: self.navigationController,
            containerView: self.navigationController!.view,
            title: BTTitle.index(0), items: items)

        menuView.cellHeight = 50
        menuView.cellBackgroundColor = UIColor.hexStringToUIColor(hex: "F4943A")
        menuView.selectedCellTextLabelColor = UIColor.lightGray
        menuView.cellSelectionColor = UIColor.hexStringToUIColor(hex: "F4943A")
        menuView.shouldKeepSelectedCellColor = true
        menuView.cellTextLabelColor = UIColor.white
        menuView.cellTextLabelFont = UIFont(name: "PingFang TC", size: 16)
        menuView.cellTextLabelAlignment = .left // .Center // .Right // .Left
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.5
        //menuView.maskBackgroundColor = UIColor.hexStringToUIColor(hex: "#F4943A")
        menuView.maskBackgroundOpacity = 0.3
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> Void in
            print("Did select item at index: \(indexPath)")
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
    
    func cateFilter(allFood: [FoodInfo], cates: [String?]) {
        
        for foodInfo in allFood {
                for cate in cates {
                    guard let foodCategory = foodInfo.foodCategory else { return }
                    if foodCategory == cate! && cate! == "肉類" {
                        self.meatsInfo.append(foodInfo) }
                     else if foodCategory == cate! && cate! == "豆類" {
                         self.beansInfo.append(foodInfo) }
                    else if foodCategory == cate! && cate! == "雞蛋類" { self.eggsInfo.append(foodInfo) }
                    else if foodCategory == cate! && cate! == "青菜類" { self.vegsInfo.append(foodInfo) }
                    else if foodCategory == cate! && cate! == "醃製類" { self.picklesInfo.append(foodInfo) }
                    else if foodCategory == cate! && cate! == "水果類" { self.fruitsInfo.append(foodInfo) }
                    else if foodCategory == cate! && cate! == "魚類" { self.fishesInfo.append(foodInfo) }
                    else if foodCategory == cate! && cate! == "海鮮類" { self.seafoodsInfo.append(foodInfo) }
                    else if foodCategory == cate! && cate! == "飲料類" { self.beveragesInfo.append(foodInfo) }
                    else if foodCategory == cate! && cate! == "調味料類"
                    { self.seasonsInfo.append(foodInfo) }
                    else if foodCategory == cate! && cate! == "其他" { self.othersInfo.append(foodInfo) }
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
    
    func deleteFoodOnShoppingList(foodId: String, complection: @escaping() -> Void) {
        
        let semaphore = DispatchSemaphore(value: 0)
        
        DispatchQueue.global().async {
        
        self.fetchAllFoodInfoInSingleShopList { foodsInfos in
            
            var newshoppingList: ShoppingList = ShoppingList(
                foodID: [""])
//                                var newshoppingList = foodsInfos.filter { $0 != foodId }
            newshoppingList.foodID = foodsInfos.filter { $0 != foodId }
            self.shoppingLists = newshoppingList.foodID

            ShoppingListManager.shared.postFoodOnShoppingList(shoppingList: &newshoppingList) { result in
                switch result{
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
        }
    }
}

// MARK: - Delegate
//    return CGSize(width: (screenSize - 16*2 - 15)/2, height: (screenSize - 16*2 - 15)/2 * 1.34)

//      func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//          print("row: \(indexPath.row)")
//      }
// delete or change to Refrige
