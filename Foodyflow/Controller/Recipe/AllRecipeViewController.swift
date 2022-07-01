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

class AllRecipeViewController: UIViewController {
    
    private var allRecipeTableView = UITableView() { didSet{allRecipeTableView.reloadData()} }
    
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
//        searchVC.navigationController?.navigationBar.backgroundColor = UIColor.FoodyFlow.darkOrange   color werid
//        let appearance = UINavigationBarAppearance()
//        appearance.backgroundColor = UIColor.FoodyFlow.darkOrange

        searchVC.searchBar.backgroundColor = UIColor.FoodyFlow.darkOrange
        searchVC.obscuresBackgroundDuringPresentation = false // 搜尋時變灰
        searchVC.searchBar.placeholder = "Enter a company or name "
        searchVC.searchBar.autocapitalizationType = .allCharacters // 全部變大寫
        
        return searchVC
    }()
    
    private lazy var addRecipe: UIButton = {
        let button = UIButton()
        return button
    }()
    // subscriber
    private var subscribers = Set<AnyCancellable>()
 //   private var searchResults: SearchResults?{didSet{allRecipeTableView.reloadData()
 //   }} // nil
    @Published private var mode: Mode = .onboarding // image / label
    @Published private var searchQuery = String() // observer changes
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        observeForm()
        allRecipeTableView.delegate = self
        allRecipeTableView.dataSource = self
   //     setupNavigationBar()
        setUI()
        allRecipeTableView.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "recipeTableViewCell")

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        allRecipeTableView.layoutIfNeeded()
        addRecipe.layer.cornerRadius = (addRecipe.frame.height)/2
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //RecipeMa//fetchAllRecipe
        RecipeManager.shared.fetchAllRecipe { [weak self] result in
        switch result {
                case .success(let recipeAmount):
                    self?.recipeAmount = recipeAmount
                    DispatchQueue.main.async {
                        self?.allRecipeTableView.reloadData()
                    }
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
        /*
        $searchQuery
            .debounce(for: .milliseconds(750), scheduler: RunLoop.main)
            .sink { [unowned self ](searchQuery) in // prevent retain cycle
                guard !searchQuery.isEmpty  else { return }
                showLoadingAnimation()
                self.apiService.fetchSymbolsPublisher(keywords: searchQuery).sink { (completion) in
                    self.hideLoadingAnimation()
                    switch completion {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .finished: break
                    }
                    
                } receiveValue: { (searchResults) in
                    self.searchResults = searchResults
//                    self.stockView.reloadData()
                    //dump(searchResults)
                }.store(in: &self.subscribers)
            }.store(in: &subscribers)
        //main track
        */
        $mode.sink { [ unowned self ] (mode) in
            switch mode {
            case .onboarding:
                //self.searchResults = nil
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
        view.addSubview(addRecipe)
        addRecipe.translatesAutoresizingMaskIntoConstraints = false
        addRecipe.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        addRecipe.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        addRecipe.widthAnchor.constraint(equalToConstant: 45).isActive = true
        addRecipe.heightAnchor.constraint(equalToConstant: 45).isActive = true
        addRecipe.layer.backgroundColor = UIColor.FoodyFlow.darkOrange.cgColor
        addRecipe.setImage(UIImage(systemName: "plus"), for: .normal)
        addRecipe.imageView?.tintColor = .white
        addRecipe.addTarget(self, action: #selector(addRecipeInDB), for: .touchUpInside)
    }
    
    func verifyUser( completion: @escaping () -> Void ) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
                    if user != nil {

                        print("\(String(describing: user?.uid))")
                        completion()
                    } else {
                        self.present( LoginViewController(), animated: true )
                        completion()
                    }
                }

    }
    
    @objc func addRecipeInDB() {
        verifyUser {
            let addRecipeVC = AddRecipeViewController(
                nibName: "AddRecipeViewController",
                bundle: nil)
            
    //        shoppingVC.refrige = refrige[0]
            self.navigationController!.pushViewController(addRecipeVC, animated: true)

        }
    }

}

extension AllRecipeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipeAmount.count
//        20 //searchResults?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = allRecipeTableView.dequeueReusableCell(
            withIdentifier: "recipeTableViewCell",
            for: indexPath) as? RecipeTableViewCell
        guard let cell = cell else { return UITableViewCell() }
        cell.recipeName.text = recipeAmount[indexPath.row].recipeName
//        cell.recipeImage.backgroundColor = .black
        return cell
    }
    
    //func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //    100
    //}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath)")
    }
    
}

extension AllRecipeViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
       // guard let searchQuery = searchController.searchBar.text, !searchQuery.isEmpty else { return }
      //  self.searchQuery = searchQuery
    }
    func willDismissSearchController(_ searchController: UISearchController) {
        mode = .onboarding
    }
    func willPresentSearchController(_ searchController: UISearchController) {
        mode = .search
    }
    
}
