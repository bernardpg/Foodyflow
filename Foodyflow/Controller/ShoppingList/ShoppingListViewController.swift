//
//  ShoppingListViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/20/22.
//

import UIKit

class ShoppingListViewController: UIViewController {
    
    private var tapButton = UIButton()
    
    var tabIndex: Int?
    
    var cate: [String?] = []
    
    var foodManager = FoodManager.shared
    
    var shoppingLists: [String?] = []
//    var shoppingLists : Refrige.init(id: "", title: "", foodID: [], createdTime: "", category: "", shoppingList: [])
    
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
    
    @IBOutlet weak var shoppingList: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shoppingList.delegate = self
        shoppingList.dataSource = self
        shoppingList.addSubview(tapButton)
        setUI()

//        shoppingList.collectionViewLayout = UICollectionViewLayout()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shoppingList.layoutIfNeeded()
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
                            
                            self?.shoppingList.reloadData()
                            semaphore.signal()
                        }
                    })
                }
            }
            
            semaphore.wait()
            
        }
    }
    
    func setUI() {

        tapButton.translatesAutoresizingMaskIntoConstraints = false
        tapButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        tapButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        tapButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        tapButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        tapButton.backgroundColor = .black
        tapButton.addTarget(self, action: #selector(addNewFood), for: .touchUpInside)
    }
    @objc func addNewFood() {
        
        let shoppingVC = ShoppingListProductDetailViewController(
            nibName: "ShoppingListProductDetailViewController",
            bundle: nil)
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
                    if foodInfo.foodCategory! == cate! && cate! == "肉類"
                    { self.meatsInfo.append(foodInfo) }
                     else if foodInfo.foodCategory! == cate! && cate! == "豆類"
                    {self.beansInfo.append(foodInfo)}
                    else if foodInfo.foodCategory! == cate! && cate! == "雞蛋類"
                    {self.eggsInfo.append(foodInfo)}
                    else if foodInfo.foodCategory! == cate! && cate! == "青菜類"
                    {self.vegsInfo.append(foodInfo)}
                    else if foodInfo.foodCategory! == cate! && cate! == "醃製類"
                    { self.picklesInfo.append(foodInfo) }
                    else if foodInfo.foodCategory! == cate! && cate! == "水果類"
                    {self.fruitsInfo.append(foodInfo)}
                    else if foodInfo.foodCategory! == cate! && cate! == "魚類"
                    {self.fishesInfo.append(foodInfo)}
                    else if foodInfo.foodCategory! == cate! && cate! == "海鮮類"
                    {self.seafoodsInfo.append(foodInfo)}
                    else if foodInfo.foodCategory! == cate! && cate! == "飲料類"
                    {self.beveragesInfo.append(foodInfo)}
                    else if foodInfo.foodCategory! == cate! && cate! == "調味料類"
                    {self.seasonsInfo.append(foodInfo)}
                    else if foodInfo.foodCategory! == cate! && cate! == "其他"
                    {self.othersInfo.append(foodInfo)}
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
    func fetchAllShoppingListInSingleRefrige(completion: @escaping([String?]) -> Void){
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

}
extension ShoppingListViewController: UICollectionViewDataSource,
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

        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "ShoppingListCollectionReusableView",
            for: indexPath) as? ShoppingListCollectionReusableView{
            sectionHeader.sectionHeaderlabel.text = cate[indexPath.section]
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
//    return CGSize(width: (screenSize - 16*2 - 15)/2, height: (screenSize - 16*2 - 15)/2 * 1.34)
    return CGSize(width: 200, height: 200)
        
    }
    
//  func collectionView(_ collectionView: UICollectionView,
//    layout collectionViewLayout: UICollectionViewLayout,
//    minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//    return 50 }

//  func collectionView(_ collectionView: UICollectionView,
//    layout collectionViewLayout: UICollectionViewLayout,
//    minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    
//        return 15

//  func collectionView(_ collectionView: UICollectionView,
//    layout collectionViewLayout: UICollectionViewLayout,
//    insetForSectionAt section: Int) -> UIEdgeInsets {
//    return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        // MARK: - Delegate
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            print("row: \(indexPath.row)")
        }
    
}


/*
let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
   
   layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
   // section與section之間的距離(如果只有一個section，可以想像成frame)
   layout.itemSize = CGSize(width: (self.view.frame.size.width - 30) / 2, height: 120)
   // cell的寬、高
   layout.minimumLineSpacing = CGFloat(integerLiteral: 10) // 滑動方向為「垂直」的話即「上下」的間距;滑動方向為「平行」則為「左右」的間距
   layout.minimumInteritemSpacing = CGFloat(integerLiteral: 10) // 滑動方向為「垂直」的話即「左右」的間距;滑動方向為「平行」則為「上下」的間距
   layout.scrollDirection = UICollectionView.ScrollDirection.vertical //UICollectionViewScrollDirection.vertical
   shoppingListCollectionView = UICollectionView()
           
   shoppingListCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), collectionViewLayout: layout)
   
   shoppingListCollectionView.dataSource = self
   shoppingListCollectionView.delegate = self
   */
 //  shoppingListCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
