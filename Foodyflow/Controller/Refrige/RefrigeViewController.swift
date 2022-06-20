//
//  RefrigeViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/16/22.
//

import UIKit

class RefrigeViewController: UIViewController {
    
    private var refrigeTableView = UITableView()
    
    private var tapButton = UIButton()
    
    var refrige: [Refrige] = []
    
    var completion: CompletionHandler?
    
    var cate = Category.init(type: [""])
    
    var models = [Model]()
    
    var foodInfo: [FoodInfo] = []
    
    var tabIndex: Int?
    
    var foodDetail: ((String) -> Void)?  // callback
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        refrigeTableView.register(RefrigeCatTableViewCell.nib(), forCellReuseIdentifier: "refrigeCatTableViewCell")
        refrigeTableView.delegate = self
        refrigeTableView.dataSource = self
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refrigeTableView.layoutIfNeeded()
        tapButton.layer.cornerRadius = (tapButton.frame.height)/2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // viewwillappear 打完重劃
        fetchAllCate()
        fetchAllRefrige { [weak self ] refrige in
            self?.fetAllFood()
        }
        refrigeTableView.reloadData()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setUI() {
        view.addSubview(refrigeTableView)
        refrigeTableView.translatesAutoresizingMaskIntoConstraints = false
        refrigeTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        refrigeTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        refrigeTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        refrigeTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                            constant: 0).isActive = true
        
        refrigeTableView.addSubview(tapButton)
        tapButton.translatesAutoresizingMaskIntoConstraints = false
        tapButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        tapButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        tapButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        tapButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        tapButton.backgroundColor = .black
        tapButton.addTarget(self, action: #selector(addNewFood), for: .touchUpInside)
    }
    @objc func addNewFood() {
        let shoppingVC = RefrigeProductDetailViewController(nibName: "ShoppingProductDetailViewController", bundle: nil)
        shoppingVC.refrige = refrige[0]
        self.navigationController!.pushViewController(shoppingVC, animated: true)
        
    }
    
    func fetchAllCate() {
        CategoryManager.shared.fetchArticles(completion: { [weak self] result in
            switch result {
            case .success(let cate):
                self?.cate.type = cate[0].type
                self?.refrigeTableView.reloadData()
        case .failure:
            print("cannot fetceeeeh data")
                
            }
        })
    }
    func fetchAllRefrige(completion: @escaping (CompletionHandler)){
        RefrigeManager.shared.fetchArticles { [weak self] result in
            switch result{
            case .success(let refrige):
                self?.refrige = refrige
                completion(["refrige" : refrige])
            case .failure:
                print("cannot fetch data")
            }
        }
    }
    func fetAllFood() {
        FoodManager.shared.fetchSpecifyFood(refrige: self.refrige[0]) { [weak self] result in
            switch result {
            case .success(let foodInfo):
                self?.foodInfo.append(foodInfo[0])
                // completion 完 作reload
                self?.refrigeTableView.reloadData()
            case .failure:
                print("fetch food error")
            }
        }
    }
    
}
extension RefrigeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cate.type.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = refrigeTableView.dequeueReusableCell(withIdentifier: "refrigeCatTableViewCell",
            for: indexPath) as? RefrigeCatTableViewCell
        guard let cell = cell else { return UITableViewCell() }
        cell.cateFood.text = self.cate.type[indexPath.row]
        // selection cell
        //
        cell.configure(with: models)
        cell.index = indexPath.row
        cell.didSelectClosure = { [weak self] tabIndex, colIndex in
            guard let tabIndex = tabIndex, let colIndex = colIndex else { return }
            let shoppingVC = RefrigeProductDetailViewController(nibName: "ShoppingProductDetailViewController", bundle: nil)
            self?.navigationController?.pushViewController(shoppingVC, animated: true)

            }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        250.0
    }
}

/*
 //            guard let text = self?.models[0].foodID[colIndex] else { return }
 //            self?.foodDetail?(text) // callback way
 //            guard let refrige = self?.refrige[0] else { return }
  //           shoppingVC.refrige = refrige
 //            shoppingVC.setFoodName(with: text)

 */
