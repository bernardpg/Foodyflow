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
    
    var models = [Model]()
    
    var tabIndex: Int?
    
    var foodDetail: ((String) -> Void)?  // callback
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        refrigeTableView.register(RefrigeCatTableViewCell.nib(), forCellReuseIdentifier: "refrigeCatTableViewCell")
        refrigeTableView.delegate = self
        refrigeTableView.dataSource = self
        
        fetchallRefrige()
  
        models.append(Model(id: "", text: "", foodID: [""]))
//        models.append(Model(text: "ee"))
//        models.append(Model(text: "22"))
//        models.append(Model(text: "12"))
//        models.append(Model(text: "42"))
//        models.append(Model(text: "rr"))
//        models.append(Model(text: "gg"))
//        models.append(Model(text: "dd"))
//        models.append(Model(text: "ww"))
//        models.append(Model(text: "qq"))
//        models.append(Model(text: "11"))
//        models.append(Model(text: "nn"))

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refrigeTableView.layoutIfNeeded() // jordan
        tapButton.layer.cornerRadius = (tapButton.frame.height)/2
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.tabBarController?.tabBar.isHidden = true 
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        let shoppingVC = ShoppingProductDetailViewController(nibName: "ShoppingProductDetailViewController", bundle: nil)
        shoppingVC.refrige = refrige[0]
        self.navigationController!.pushViewController(shoppingVC, animated: true)
        
    }
    
    func fetchallRefrige() {
        RefrigeManager.shared.fetchArticles { [weak self] result in
            switch result{
            case .success(let refrige):
                self?.refrige = refrige
                if self?.models[0].text != ""{
                self?.models.append(Model(id: refrige[0].id, text: refrige[0].title, foodID: refrige[0].foodID))
                }
                else {
                    self?.models[0].id = refrige[0].id
                    self?.models[0].text = refrige[0].title
                    self?.models[0].foodID = refrige[0].foodID
                }
                self?.refrigeTableView.reloadData()
        case .failure:
            print("cannot fetceeeeh data")
                
            }
        }
    }
    
}
extension RefrigeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  models[0].id.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = refrigeTableView.dequeueReusableCell(withIdentifier: "refrigeCatTableViewCell",
            for: indexPath) as? RefrigeCatTableViewCell
        guard let cell = cell else { return UITableViewCell() }
        cell.index = indexPath.row
        cell.didSelectClosure = { [weak self] tabIndex, colIndex in
            guard let tabIndex = tabIndex, let colIndex = colIndex else { return }
            
            let shoppingVC = ShoppingProductDetailViewController(nibName: "ShoppingProductDetailViewController", bundle: nil)
            guard let text = self?.models[0].foodID[colIndex] else { return }
            self?.foodDetail?(text) // callback way
            guard let refrige = self?.refrige[0] else { return }
            shoppingVC.refrige = refrige
            shoppingVC.setFoodName(with: text)
            self?.navigationController!.pushViewController(shoppingVC, animated: true)

        }

        cell.configure(with: models)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        250.0
    }
}
