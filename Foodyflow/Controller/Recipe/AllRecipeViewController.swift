//
//  AllRecipeViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/27/22.
//

import UIKit
import SnapKit
import Combine
import FirebaseAuth
import Kingfisher
import PKHUD
import SwifterSwift

// block user

class AllRecipeViewController: UIViewController {
    
    private lazy var allRecipeTableView = UITableView() { didSet { allRecipeTableView.reloadData()} }
    
    private enum Mode {
        case onboarding
        case search
    }
    
    private var recipeAmount: [Recipe] = []
    
    private lazy var searchController: UISearchController = {
        let searchVC = UISearchController(searchResultsController: nil)
        allRecipeTableView.tableHeaderView = searchVC.searchBar
        searchVC.searchResultsUpdater = self // search 更新等於自己
        searchVC.delegate = self
        //navigationItem.titleView = searchController.searchBar
        searchVC.navigationController?.navigationBar.backgroundColor = UIColor.FoodyFlow.lightOrange   //color werid
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
    
    private var searchResults: SearchResults?{didSet{allRecipeTableView.reloadData() }} // nil
    @Published private var mode: Mode = .onboarding // image / label
    @Published private var searchQuery = String() // observer changes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeForm()
        allRecipeTableView.delegate = self
        allRecipeTableView.dataSource = self
        setupNavigationBar()
        setUI()
        allRecipeTableView.register(UINib(nibName: "RecipeTableViewCell",
                                          bundle: nil),
                                    forCellReuseIdentifier: "recipeTableViewCell")
        
        searchController.hidesNavigationBarDuringPresentation = false
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
        self.searchController.searchBar.isHidden = false
        // RecipeMa // fetchAllRecipe
        RecipeManager.shared.fetchAllRecipe { [weak self] result in
        switch result {
        case .success(let recipeAmount):
                self?.recipeAmount = recipeAmount
                DispatchQueue.main.async {
                    self?.allRecipeTableView.reloadData() }
        case .failure:
                    print("cannot fetch data")
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
                    //dump(searchResults)
                }.store(in: &self.subscribers)
            }.store(in: &subscribers)
        //main track
        
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
    
    struct APIService{
        
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
    
    struct SearchResults: Codable{
        
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

extension AllRecipeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipeAmount.count
//        20 //searchResults?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = allRecipeTableView.dequeueReusableCell(
            withIdentifier: "recipeTableViewCell",
            for: indexPath) as? RecipeTableViewCell
        guard let cell = cell else { return UITableViewCell() }
        cell.recipeName.text =
        recipeAmount[indexPath.row].recipeName
     //   if let searchResults = self.searchResults {
     //       let searchResult = searchResults.items[indexPath.row]
     //       cell.recipeName.text = searchResult.name
            // cell.configure(with: searchResult)
     //   }
        if recipeAmount[indexPath.row].recipeImage == "" {
        cell.recipeImage.image = UIImage(named: "imageDefault") } else {
            //        cell.recipeImage.download(from: URL(string: recipeAmount[indexPath.row].recipeImage)!)
            cell.recipeImage.kf.setImage(with: URL(string: recipeAmount[indexPath.row].recipeImage))
            
        }
        cell.recipeImage.clipsToBounds = true
        cell.recipeImage.contentMode = .scaleAspectFill
        cell.recipeImage.lkCornerRadius = 20
        return cell
    }
    
    // MARK: - send pic unfinished
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        fetchSingleRecipe(recipe: recipeAmount[indexPath.row]) { recipe in
    
            DispatchQueue.main.async {
                
                let addRecipeVC = AddRecipeViewController(nibName: "AddRecipeViewController", bundle: nil)
                HandleResult.readData.messageHUD
                addRecipeVC.recipeName = recipe?.recipeName ?? ""
                addRecipeVC.recipeFood = recipe?.recipeFood ?? ""
                addRecipeVC.recipeStep = recipe?.recipeStep ?? ""
                addRecipeVC.recipeInImage = recipe?.recipeImage ?? ""
                self.navigationController!.pushViewController(addRecipeVC, animated: true)
                self.searchController.searchBar.isHidden = true
            }
            
        }
    }
        
}

extension AllRecipeViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchQuery = searchController.searchBar.text, !searchQuery.isEmpty else { return }
        self.searchQuery = searchQuery
    }
    func willDismissSearchController(_ searchController: UISearchController) {
        mode = .onboarding
    }
    func willPresentSearchController(_ searchController: UISearchController) {
        mode = .search
    }
    
}
