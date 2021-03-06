//
//  AllRecipeViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/27/22.
//

// block user long touch
// 點擊愛心 deque error

import UIKit
import SnapKit
import Combine
import FirebaseAuth
import Kingfisher
import PKHUD
import SwifterSwift

class AllRecipeViewController: UIViewController {
    
    private lazy var allRecipeTableView = UITableView() { didSet { allRecipeTableView.reloadData()} }
    
    private enum Mode {
        case onboarding
        case search
    }
        
    private var recipeAmount: [Recipe] = []
    private var usersinfo: UserInfo? { didSet { fetchReload() } }
    
    private lazy var searchController: UISearchController = {
        let searchVC = UISearchController(searchResultsController: nil)
        allRecipeTableView.tableHeaderView = searchVC.searchBar
        searchVC.searchResultsUpdater = self // search 更新等於自己
        searchVC.delegate = self
        // navigationItem.titleView = searchController.searchBar
        searchVC.navigationController?.navigationBar.backgroundColor = UIColor.FoodyFlow.lightOrange   // color werid
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.FoodyFlow.darkOrange
        searchVC.searchBar.backgroundColor = UIColor.FoodyFlow.white
        searchVC.obscuresBackgroundDuringPresentation = false // 搜尋時變灰
        searchVC.searchBar.placeholder = "輸入你想找的食譜 "
        searchVC.searchBar.autocapitalizationType = .allCharacters // 全部變大寫
        
        return searchVC
    }()
    
    private let apiService = APIService()
    
    // subscriber
    private var subscribers = Set<AnyCancellable>()
    
    private var searchResults: SearchResults? {didSet {allRecipeTableView.reloadData() }} // nil
    @Published private var mode: Mode = .onboarding // image / label
    @Published private var searchQuery = String() // observer changes
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        observeForm()
        allRecipeTableView.delegate = self
        allRecipeTableView.dataSource = self
//        setupNavigationBar()
        setUI()
        allRecipeTableView.register(UINib(nibName: "RecipeTableViewCell",
                                          bundle: nil),
                                    forCellReuseIdentifier: "recipeTableViewCell")
        
        searchController.hidesNavigationBarDuringPresentation = false
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        allRecipeTableView.addGestureRecognizer(longPress)
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        UserManager.shared.fetchUserInfo(fetchUserID: userID) { result in
            switch result {
            case .success(let userInfo):
                self.usersinfo = userInfo
                
            case .failure:
                HandleResult.readDataFailed.messageHUD
            }
        }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        allRecipeTableView.layoutIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchController.searchBar.isHidden = true

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchController.searchBar.isHidden = true
//        self.searchController.searchBar.isHidden = false
        // RecipeMa // fetchAllRecipe
        fetchRecipe()
    }
    
    func fetchRecipe() {
        
        RecipeManager.shared.fetchAllRecipe {  result in
        switch result {
        case .success(let recipeAmount):
            self.recipeAmount = recipeAmount.filter { !(self.usersinfo?.blockLists.contains($0.recipeName) ?? true)
            }
                self.recipeAmount = recipeAmount
                DispatchQueue.main.async {
                    self.allRecipeTableView.reloadData() }
        case .failure:
                    print("cannot fetch data")
            }
        }

    }
    
    func fetchReload() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        UserManager.shared.fetchUserInfo(fetchUserID: userID) { result in
            switch result {
            case .success(let userInfo):
                self.usersinfo = userInfo
                self.fetchRecipe()
            case .failure:
                HandleResult.readDataFailed.messageHUD
            }
        }

    }
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: allRecipeTableView)
            if let indexPath = allRecipeTableView.indexPathForRow(at: touchPoint) {
                self.blockUser(indexPathRow: indexPath.row)
            }
        }
    }
    
    private func blockUser ( indexPathRow: Int ) {
        
        let alert = UIAlertController(title: "封鎖用戶",
                                      message: "是否封鎖\(recipeAmount[indexPathRow].recipeUserName)",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "封鎖並舉報", style: .destructive) { _  in

        self.blockUserById(blockID: self.recipeAmount[indexPathRow].recipeUserID) {
            UserManager.shared.fetchUserInfo(fetchUserID: self.usersinfo?.userID ?? "") { result in
                switch result {
                case .success(let myownUserInfo):
                    self.usersinfo = myownUserInfo
                case .failure:
                    HandleResult.addDataFailed.messageHUD
                }
            }

                print("ook")
        }
        // po blockUser fetall block user and filter
            
        /*    self.blockUserById(userID: self.recipeAmount[indexPathRow].recipeUserID) {

                RecipeManager.shared.fetchAllRecipe { result in
                switch result {
                case .success(let recipes):
                    recipes.filter { recipe in
  //                      recipe.recipeUserID !=
                        recipe.recipeFood != nil
                    }
                case .failure:
                    print("no")

                }
            }
        }*/
            
        }
        alert.addAction(okAction)
        let falseAction = UIAlertAction(title: "取消", style: .cancel)
        alert.addAction(falseAction)
        
        alert.show(animated: true, vibrate: true)
    }
    
    private func blockUserById(blockID: String, completion: @escaping () -> Void) {
        
        verifyUser {
            
            guard let userID = Auth.auth().currentUser?.uid else { return }
            
            UserManager.shared.addBlockList(uid: userID, blockID: blockID) { result in
                switch result {
                case .success:
                    completion()

                case .failure:
                    HandleResult.readDataFailed.messageHUD
                }
            }
            
        }
        
    }
    
    func verifyUser( completion: @escaping () -> Void) {
        Auth.auth().addStateDidChangeListener { ( _, user) in
            if user != nil {
                guard let user = user?.uid else {
                    return
                }
                self.fetchUserByUserID(userID: user) { _ in
                    completion()
                }
                                
            } else {
                self.present( LoginViewController(), animated: true )
                completion()
            }
        }
        
    }
    
    func fetchUserByUserID(userID: String, completion: @escaping (UserInfo) -> Void ) {
        
        self.fetchUser(userID: userID) { userInfo in
            completion(userInfo)
            
        }
            
    }
    
    func fetchUser(userID: String, completion: @escaping (UserInfo) -> Void) {
        UserManager.shared.fetchUserInfo(fetchUserID: userID) { result in
            
            switch result {
            case.success(let userInfo):
                completion(userInfo)
            case.failure:
                print(LocalizedError.self)
            }
        }
    }

    private func setupNavigationBar() {
        navigationItem.searchController = searchController // 實例
        navigationItem.title = "Search "
    }
    
    private func observeForm() {
        
        $searchQuery
            .debounce(for: .milliseconds(750), scheduler: RunLoop.main)
            .sink { [unowned self ](searchQuery) in // prevent retain cycle
                guard !searchQuery.isEmpty  else { return }
               // showLoadingAnimation()
                self.apiService.fetchSymbolsPublisher(keywords: searchQuery).sink { (completion) in
              //      self.hideLoadingAnimation()
                    switch completion {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .finished: break
                    }

                } receiveValue: { (searchResults) in
                    self.searchResults = searchResults
                    self.allRecipeTableView.reloadData()
                    // dump(searchResults)
                }.store(in: &self.subscribers)
            }.store(in: &subscribers)
        // main track
        
        $mode.sink { [ unowned self ] (mode) in
            switch mode {
            case .onboarding:
                // self.searchResults = nil
                // each cancel will become nil
                self.allRecipeTableView.backgroundView = SearchPlaceholderView()
                self.allRecipeTableView.reloadData()
            case .search:
                self.allRecipeTableView.backgroundView = nil
            }
        }.store(in: &subscribers)
    }
    
    func setUI() {
        view.addSubview(allRecipeTableView)
        allRecipeTableView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.bottom.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
        }
    }
    
    // array Union 改寫
    func likeRecipe( userInfo: UserInfo, needtoLike: String, completion: @escaping () -> Void) {
        var newUserInfo = userInfo
        
        // recipeChangeLike
        newUserInfo.personalLikeRecipe.append(needtoLike)
        UserManager.shared.updateUserInfo(user: newUserInfo) {
            
        }
        
    }
    
    func fetchSingleRecipe(recipe: Recipe, completion: @escaping(Recipe?) -> Void) {
        RecipeManager.shared.fetchSingleRecipe(recipe: recipe) { result in
            switch result {
            case .success(let recipe):
                completion( recipe )
            case .failure:
                print("cannot fetceeeeh data")
            }
        }
    }
    
    struct APIService {
        
        var apiKey: String {
            
            return keys.randomElement() ?? ""
        
        }
        
        let keys = ["M3JECHM5Y5C46W0D"]
        
        func fetchSymbolsPublisher(keywords: String) -> AnyPublisher<SearchResults, Error> {
            
            let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keywords)&apikey=\(apiKey)"
            let url = URL(string: urlString)!
            
            return URLSession.shared.dataTaskPublisher(for: url).map({$0.data}).decode(type: SearchResults.self, decoder: JSONDecoder()).receive(on: RunLoop.main).eraseToAnyPublisher()
        
        }
    }
    
    struct SearchResults: Codable {
        
        let items: [SearchResult]
        
        enum CodingKeys: String, CodingKey {
        
            case items = "bestMatches"
            
        }
    }

    struct SearchResult: Codable {
        
        let symbol: String
        let name: String
        let type: String
        let currency: String
        
        enum CodingKeys: String, CodingKey {
            case symbol = "1. symbol"
            case name = "2. name"
            case type = "3. type"
            case currency = "8. currency"
        }
    }

}

extension AllRecipeViewController: UITableViewDelegate, UITableViewDataSource, RecipeLikeDelegate {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipeAmount.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = allRecipeTableView.dequeueReusableCell(
            withIdentifier: "recipeTableViewCell",
            for: indexPath) as? RecipeTableViewCell
        guard let cell = cell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.delegate = self
        cell.indexPath = indexPath
        cell.recipeName.font = UIFont(name: "PingFang TC", size: 20)
        cell.recipeUserName.font =  UIFont(name: "PingFang TC", size: 16)

        cell.recipeName.text =
        recipeAmount[indexPath.row].recipeName

        if recipeAmount[indexPath.row].recipeImage == "" {
        cell.recipeImage.image = UIImage(named: "imageDefault") } else {
            cell.recipeImage.kf.setImage(with: URL(string: recipeAmount[indexPath.row].recipeImage)) }
        cell.recipeUserName.text = recipeAmount[indexPath.row].recipeUserName
        cell.recipeImage.clipsToBounds = true
        cell.recipeImage.contentMode = .scaleAspectFill
        cell.recipeImage.lkCornerRadius = 20
        cell.likeRecipeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        guard let usersinfo = usersinfo else { return cell }
        
        for personalike in usersinfo.personalLikeRecipe {
            if personalike == recipeAmount[indexPath.row].recipeID {
                cell.likeRecipeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                cell.likeRecipeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }

        return cell
    }
    
    // MARK: - send pic unfinished
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        fetchSingleRecipe(recipe: recipeAmount[indexPath.row]) { recipe in
    
            DispatchQueue.main.async {
                
                let readRecipeVC = ReadRecipeViewController(nibName: "ReadRecipeViewController", bundle: nil)
                readRecipeVC.recipeNames = recipe?.recipeName ?? ""
                readRecipeVC.recipeFoods = recipe?.recipeFood ?? ""
                readRecipeVC.recipeSteps = recipe?.recipeStep ?? ""
                readRecipeVC.recipeInImage = recipe?.recipeImage ?? ""
                readRecipeVC.recipeDoName = recipe?.recipeUserName ?? ""
                self.navigationController!.pushViewController(readRecipeVC, animated: true)
                self.searchController.searchBar.isHidden = true
            }
            
        }
    }
    
    func didLikeTap(indexPathRow: IndexPath) {
        
        Auth.auth().addStateDidChangeListener { ( _, user) in
            if user != nil {
                
                let likeRecipe = self.recipeAmount[indexPathRow.row].recipeID
                
                self.fetchUser(userID: Auth.auth().currentUser?.uid ?? "") { userInfo in
                    self.likeRecipe(userInfo: userInfo, needtoLike: "\(likeRecipe)") {
                        
                    }
                }
                                
            } else {
                
                self.present( LoginViewController(), animated: true )
            }
        }

    }

}

extension AllRecipeViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchQuery = searchController.searchBar.text, !searchQuery.isEmpty else { return }
        self.searchQuery = searchQuery }
    func willDismissSearchController(_ searchController: UISearchController) {
        mode = .onboarding }
    func willPresentSearchController(_ searchController: UISearchController) {
        mode = .search }
    
}
