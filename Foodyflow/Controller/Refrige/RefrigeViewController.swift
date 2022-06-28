//
//  RefrigeViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/16/22.
//

import UIKit
import CoreMedia
import CoreMIDI
import BTNavigationDropdownMenu
import LZViewPager
import SnapKit
// MARK: - fetch for change UI and add photos
// logic change for fetch on this VC
// MARK: - create Recipe Page

// MARK: = change Refrige and shoppingList

class RefrigeViewController: UIViewController, LZViewPagerDelegate, LZViewPagerDataSource {
    
    // 先抓第一個冰箱 再依照用戶選擇哪一個再去抓下面那層
    // 如果沒有的話 就要顯示創立冰箱 // 空的 VC
    
    var refrigeTableView = UITableView() //{didSet{refrigeTableView.reloadData() }}
    
    private lazy var expiredRefrigeVC = ExpiredRefirgeViewController()
    
    private lazy var threeDaysRefrigeVC = WithinThreeDaysRefirgeViewController()
    
    private lazy var refrigeAllFoodVC = RefrigeAllFoodViewController()
    
    // this vc inside it
    
    private var viewPager =  LZViewPager()
    
    private lazy var containerView: [UIViewController] = []
    
    var menuView: BTNavigationDropdownMenu!

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
    
    var didSelectDifferentRef: Int? //{didSet{reloadRefrige()}}
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewPagerProperties()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
                
                self?.setDropdown(self?.refrige)

                self?.resetRefrigeFood()
                
                self?.fetAllFood(completion: { foodinfo21 in
                    
                    guard let cates = self?.cate else { return }
                    
//                    self?.cateFilter(allFood: foodinfo21, cates: cates)
                    
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
    
    func fetchAllRefrige() {
        RefrigeManager.shared.fetchArticles { [weak self] result in
            switch result {
            case .success(let refrigeAmount):
                self?.refrige = refrigeAmount
                DispatchQueue.main.async {
//                    self?.personalTableView.reloadData()
                }
            case .failure:
                print("cannot fetch data")
            }
        }
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
                    if foodCategory == cate! && cate! == "肉類" {
                        self.meatsInfo.append(foodInfo)
                    }
                     else if foodCategory == cate! && cate! == "豆類" { self.beansInfo.append(foodInfo)
                     }
                    else if foodCategory == cate! && cate! == "雞蛋類" {
                        self.eggsInfo.append(foodInfo)
                    }
                    else if foodCategory == cate! && cate! == "青菜類" { self.vegsInfo.append(foodInfo)
                        
                    }
                    else if foodCategory == cate! && cate! == "醃製類" { self.picklesInfo.append(foodInfo)
                    }
                    else if foodCategory == cate! && cate! == "水果類" { self.fruitsInfo.append(foodInfo)
                    }
                    else if foodCategory == cate! && cate! == "魚類" { self.fishesInfo.append(foodInfo)
                    }
                    else if foodCategory == cate! && cate! == "海鮮類" { self.seafoodsInfo.append(foodInfo)
                    }
                    else if foodCategory == cate! && cate! == "飲料類" { self.beveragesInfo.append(foodInfo)
                    }
                    else if foodCategory == cate! && cate! == "調味料類" { self.seasonsInfo.append(foodInfo)
                        
                    }
                    else if foodCategory == cate! && cate! == "其他" { self.othersInfo.append(foodInfo)
                    }
                }
            }

    }
    
    func reloadRefrige() {
        
        let semaphore = DispatchSemaphore(value: 0)
        
        DispatchQueue.global().async {

        self.resetRefrigeFood()
        
        self.fetAllFood(completion: { foodinfo21 in
            
//            self.cateFilter(allFood: foodinfo21, cates: self.cate)
            
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
    
    //  wait for change
    func setDropdown(_ refriges: [Refrige]?) {
        var items: [String] = []
        
        guard let refriges = refriges else {
            return
        }
        for refrige in refriges {
            items.append(refrige.title )
        }
      //  self.selectedCellLabel.text = items.first
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.hexStringToUIColor(hex: "F4943A")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        menuView = BTNavigationDropdownMenu(
            navigationController: self.navigationController,
            containerView: self.navigationController!.view,
            title: BTTitle.index(0), items: items)
// W fetch return
        // Another way to initialize:
        // menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: BTTitle.title("Dropdown Menu"), items: items)
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = UIColor.hexStringToUIColor(hex: "F4943A")
        menuView.selectedCellTextLabelColor = UIColor.lightGray
        menuView.cellSelectionColor = UIColor.hexStringToUIColor(hex: "F4943A")
        menuView.shouldKeepSelectedCellColor = true
        menuView.cellTextLabelColor = UIColor.white
        menuView.cellTextLabelFont = UIFont(name: "Avenir-Heavy", size: 17)
        menuView.cellTextLabelAlignment = .left // .Center // .Right // .Left
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.5
        //menuView.maskBackgroundColor = UIColor.hexStringToUIColor(hex: "#F4943A")
        menuView.maskBackgroundOpacity = 0.3
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> Void in
            print("Did select item at index: \(indexPath)")
        self.didSelectDifferentRef = indexPath
            self.refrigeAllFoodVC.didSelectDifferentRef = indexPath
            self.threeDaysRefrigeVC.didSelectDifferentRef = indexPath
            self.expiredRefrigeVC.didSelectDifferentRef = indexPath
        }
        
        self.navigationItem.titleView = menuView
    }
    
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

        refrigeAllFoodVC.title = "allFood"
        threeDaysRefrigeVC.title = "threeDaysExpire"
        expiredRefrigeVC.title = "expired"
        
        containerView = [ refrigeAllFoodVC,
                          threeDaysRefrigeVC,
                          expiredRefrigeVC]
        
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
        button.setTitleColor(UIColor.B1, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.backgroundColor = .black
        return button
    }
    
    // change refrige
//    refrigeNow = refrige[0]
    
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
    func fetAllFood(completion: @escaping([FoodInfo]) -> Void) {
        self.foodsInfo = []
        FoodManager.shared.fetchSpecifyFood(
            refrige: self.refrige[self.didSelectDifferentRef ?? 0])
        { [weak self] result in
            switch result {
            case .success(let foodInfo):
                if ((foodInfo.foodId?.isEmpty) != nil)
                { self?.foodsInfo.append(foodInfo)
                    if self?.foodsInfo.count == self?.refrige[self?.didSelectDifferentRef ?? 0].foodID.count
                    {completion(self?.foodsInfo ?? [foodInfo])}
                    else { print("append not finish yet ") }
                }
                else {completion([foodInfo])}
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
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = refrigeTableView.dequeueReusableCell(withIdentifier: "refrigeCatTableViewCell",
            for: indexPath) as? RefrigeCatTableViewCell
        guard let cell = cell else { return UITableViewCell() }
        cell.cateFood.text = self.cate[indexPath.row]
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
            self?.navigationController?.pushViewController(shoppingVC,animated: true)}
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        250.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // UIAlert to didselect or delete
        
    }
}
