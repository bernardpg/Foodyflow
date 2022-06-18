//
//  RefrigeViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/16/22.
//

import UIKit

class RefrigeViewController: UIViewController {
    
    private var refrigeTableView = UITableView()
    
    var models = [Model]()
    
    var tabIndex: Int?
    
    var foodDetail: ((String) -> Void)?  // callback
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        refrigeTableView.register(RefrigeCatTableViewCell.nib(), forCellReuseIdentifier: "refrigeCatTableViewCell")
        refrigeTableView.delegate = self
        refrigeTableView.dataSource = self
        
        models.append(Model(text: "ee"))
        models.append(Model(text: "22"))
        models.append(Model(text: "12"))
        models.append(Model(text: "42"))
        models.append(Model(text: "rr"))
        models.append(Model(text: "gg"))
        models.append(Model(text: "dd"))
        models.append(Model(text: "ww"))
        models.append(Model(text: "qq"))
        models.append(Model(text: "11"))
        models.append(Model(text: "nn"))

    }
    
    func setUI() {
        view.addSubview(refrigeTableView)
        refrigeTableView.translatesAutoresizingMaskIntoConstraints = false
        refrigeTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        refrigeTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        refrigeTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        refrigeTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                            constant: 0).isActive = true
    }
    
}
extension RefrigeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3 // cate count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = refrigeTableView.dequeueReusableCell(withIdentifier: "refrigeCatTableViewCell",
            for: indexPath) as? RefrigeCatTableViewCell
        guard let cell = cell else { return UITableViewCell() }
        cell.index = indexPath.row
        cell.didSelectClosure = { [weak self] tabIndex, colIndex in
            guard let tabIndex = tabIndex, let colIndex = colIndex else { return }
            
            let shoppingVC = ShoppingProductDetailViewController(nibName: "ShoppingProductDetailViewController", bundle: nil)
            guard let text = self?.models[colIndex].text else { return }
            self?.foodDetail?(text) // callback way
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
