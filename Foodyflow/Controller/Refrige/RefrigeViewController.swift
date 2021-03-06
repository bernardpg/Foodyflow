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
import Combine
import FirebaseAuth

// launchScreen

// refirige 要 dropdown 下拉才會更新  // fetch順序可能會有不同

// refrige  內部未完全更改
    
// shoppinglist 也是

//  fetch 資料及更改 再次確認

// MARK: - fetch for change UI and add photos
// logic change for fetch on this VC
// MARK: - create Recipe Page

// MARK: = change Refrige and shoppingList

class RefrigeViewController: UIViewController, LZViewPagerDelegate, LZViewPagerDataSource {
    
    // 先抓第一個冰箱 再依照用戶選擇哪一個再去抓下面那層
    // 如果沒有的話 就要顯示創立冰箱 // 空的 VC
    
    var refrigeTableView = UITableView() // {didSet{refrigeTableView.reloadData() }}
    
    private lazy var expiredRefrigeVC = ExpiredRefirgeViewController()
    
    private lazy var threeDaysRefrigeVC = WithinThreeDaysRefirgeViewController()
    
    private lazy var refrigeAllFoodVC = RefrigeAllFoodViewController()
        
    private lazy var viewPager =  LZViewPager()
    
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
    
    var userManager = UserManager()
    
    var tabIndex: Int?
    
    var onPublished: (() -> Void)?
    
    var foodDetail: ((String) -> Void)?  // callback
    
    var didSelectDifferentRef: Int? // {didSet{reloadRefrige()}}
    
    private lazy var notiname = Notification.Name("dropDownReloadNoti")

    private enum Mode {
        case onboarding
        case login
    }
    
    // subscriber
    private var subscribers = Set<AnyCancellable>()
    
    @Published private var mode: Mode = .onboarding // image / label

    override func viewDidLoad() {
        super.viewDidLoad()
        observeForm()
        viewPagerProperties()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDropdown), name: notiname, object: nil)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Auth.auth().addStateDidChangeListener { (_, user) in
            if user != nil {
                guard let userID = user?.uid else { return }
                
                self.fetchAllCate { [weak self] cates in
                    self?.cate = cates }
                
                self.userLoadRefrige(userID: userID)
                                            
            } else {
                    self.present( LoginViewController(), animated: true)
                    self.setDropdown(self.refrige)
                    }
                }
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func observeForm() {
        $mode.sink { [ unowned self ] (mode) in
            switch mode {
            case .onboarding:
//                self.searchResults = nil
                // each cancel will become nil
                self.refrigeAllFoodVC.refrigeTableView.backgroundView = RefrigeView()
                self.refrigeAllFoodVC.refrigeTableView.reloadData()
            case .login:
                self.refrigeAllFoodVC.refrigeTableView.backgroundView = nil
            }
        }.store(in: &subscribers)
    }
    
    @objc func reloadDropdown() {
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        self.fetchAllCate { [weak self] cate in
            self?.cate = cate }
        
        self.userLoadRefrige(userID: userID)
    }
        
    func userLoadRefrige(userID: String) {
        
        let semaphore = DispatchSemaphore(value: 0)
        
        DispatchQueue.global().async {

        self.userManager.fetchUserInfo(fetchUserID: userID) { result in
            switch result {
            case .success(let userInfo):
                self.fetchAllRefrige(userRefriges: userInfo.personalRefrige) { [weak self] refrige in
                    
                    self?.setDropdown(self?.refrige)
                    guard !(self?.refrige.isEmpty ?? true) else { return }
                    // MARK: - initial open refrige as one
                    refrigeNow = self?.refrige[0]
                    DispatchQueue.main.async {
                                    // lottie 消失
                    self?.refrigeTableView.reloadData()
                    semaphore.signal()
                    }
                    
                }
            case .failure:
                        HandleResult.readDataFailed.messageHUD
                    }
            
        }
        semaphore.wait()
        }
    }
    
   /* func reloadRefrige() {
        
        let semaphore = DispatchSemaphore(value: 0)
        
        DispatchQueue.global().async {

        self.resetRefrigeFood()
        self.fetAllFood(completion: { _ in
                        
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
    }*/
    
    func fetchAllRefrige(userRefriges: [String?], completion: @escaping (CompletionHandler)) {
        
        if userRefriges.isEmpty {
            self.refrige = []
            completion(["refrige": []])}
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

    // MARK: reset refrige
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
                    guard let foodCategory = foodInfo.foodCategory
                    else { return }
                    if foodCategory == cate! && cate! == "肉類" {
                        self.meatsInfo.append(foodInfo) } else if
                        foodCategory == cate! && cate! == "豆類" {
                        self.beansInfo.append(foodInfo) } else if
                        foodCategory == cate! && cate! == "雞蛋類" {
                        self.eggsInfo.append(foodInfo) } else if
                        foodCategory == cate! && cate! == "青菜類" {
                        self.vegsInfo.append(foodInfo) } else if
                        foodCategory == cate! && cate! == "醃製類"{
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
                        self.othersInfo.append(foodInfo) } }
            
        }

    }
    
    //  wait for change

    // change refrige
//    refrigeNow = refrige[0]
    
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
                    { completion(self?.foodsInfo ?? [foodInfo])} else{
                    print("append not finish yet ") }
                }
                else {completion([foodInfo])}
            case .failure:
                print("fetch food error")
            }
        }
    }
    
    // MARK: dropDown and container UI
    
    func setDropdown(_ refriges: [Refrige]?) {
        var items: [String] = []
        
        guard let refriges = refriges else {
            return
        }
        for refrige in refriges {
            items.append(refrige.title )
        }
    //    self.didSelectDifferentRef = 0
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = UIColor.FoodyFlow.darkOrange
        self.navigationController?.navigationBar.barTintColor = UIColor.FoodyFlow.darkOrange
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        if items.count == 0 {
            items = ["我的冰箱"]
            menuView = BTNavigationDropdownMenu(
                navigationController: self.navigationController,
                containerView: self.navigationController!.view,
                title: BTTitle.index(0), items: items)
                refrigeNow = nil
                menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> Void in
                    print("Did select item at index: \(indexPath)")}
        } else {
            
        menuView = BTNavigationDropdownMenu(
            navigationController: self.navigationController,
            containerView: self.navigationController!.view,
            title: BTTitle.index(didSelectDifferentRef ?? 0), items: items)
            menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> Void in
                print("Did select item at index: \(indexPath)")
            self.didSelectDifferentRef = indexPath
            refrigeNow =  self.refrige[self.didSelectDifferentRef ?? 0]
            self.refrigeAllFoodVC.didSelectDifferentRef = indexPath
            self.threeDaysRefrigeVC.didSelectDifferentRef = indexPath
                self.expiredRefrigeVC.didSelectDifferentRef = indexPath        }
        }
        menuView.navigationBarTitleFont = UIFont(name: "PingFang TC", size: 20)
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = UIColor.FoodyFlow.darkOrange
        menuView.selectedCellTextLabelColor = UIColor.lightGray
        menuView.cellSelectionColor = UIColor.FoodyFlow.darkOrange
        menuView.shouldKeepSelectedCellColor = true
        menuView.cellTextLabelColor = UIColor.white
        menuView.cellTextLabelFont =  UIFont(name: "PingFang TC", size: 20)
        menuView.cellTextLabelAlignment = .left
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.5
        menuView.maskBackgroundOpacity = 0.3

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

        refrigeAllFoodVC.title = "全部食材"
        threeDaysRefrigeVC.title = "三日內過期"
        expiredRefrigeVC.title = "已過期"
        
        containerView = [ refrigeAllFoodVC,
                          threeDaysRefrigeVC,
                          expiredRefrigeVC]
        
        viewPager.reload()
        
    }
    
    func heightForIndicator(at index: Int) -> CGFloat {
        return CGFloat(6)
    }
    
    func heightForHeader() -> CGFloat {
        return CGFloat(50)
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
        cell.cateFood.font = UIFont(name: "PingFang TC", size: 18)
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
            self?.navigationController?.pushViewController( shoppingVC, animated: true) }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        250.0
    }
    
}
