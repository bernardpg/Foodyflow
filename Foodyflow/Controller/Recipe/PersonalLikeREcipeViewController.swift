//
//  PersonalLikeREcipeViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/26/22.
//

import UIKit
import SnapKit
import FirebaseAuth
import CoreMedia

class PersonalLikeREcipeViewController: UIViewController {
    
    private lazy var addRecipe: UIButton = {
        let button = UIButton()
        return button
    }()
    
    var tableViewData = [PersonalRecipe]()
    
    @IBOutlet weak var personalLikeTableView: UITableView!
    
    private lazy var personalRecipeTableView =  UITableView()
    
    let attrs1 = [NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor : UIColor.hexStringToUIColor(hex: "22AA6")]

    let attrs2 = [NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: 24), NSAttributedString.Key.foregroundColor : UIColor.FoodyFlow.darkOrange]

    override func viewDidLoad() {
        
        super.viewDidLoad()
        personalRecipeTableView.delegate = self
        personalRecipeTableView.dataSource = self
        
        personalRecipeTableView.register(UINib(nibName: "PresonalLikeTableViewCell", bundle: nil), forCellReuseIdentifier: "presonalLikeTableViewCell")
        
        personalRecipeTableView.register(UINib(nibName:
            "PersonalRecipeTableViewCell", bundle: nil),
        forCellReuseIdentifier: "personalrecipeTableViewCell")
        
        personalRecipeTableView.register(UINib(nibName:
            "PersonalTitleTableViewCell", bundle: nil),
        forCellReuseIdentifier: "personalrecipeTitleTableViewCell")
        
        tableViewData = [PersonalRecipe(opened: false, title: "我的食譜", sectionData: ["cell1", "cell2", "cell"]),
        PersonalRecipe(opened: false, title: "收藏食譜", sectionData: ["cell12", "cell23", "cell34"])]
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addRecipe.layer.cornerRadius = (addRecipe.frame.height)/2

    }
    
    private func setupUI() {
        
    view.addSubview(personalRecipeTableView)
        
    personalRecipeTableView.snp.makeConstraints { make in
        make.top.equalTo(view)
        make.leading.equalTo(view)
        make.trailing.equalTo(view)
        make.bottom.equalTo(view)
        }
    
    personalRecipeTableView.addSubview(addRecipe)
    
    addRecipe.snp.makeConstraints { make in
        make.trailing.equalTo(view).offset(-16)
        make.bottom.equalTo(view.snp_bottomMargin).offset(-16)
        make.width.equalTo(45)
        make.height.equalTo(45)
    }
        
    addRecipe.layer.backgroundColor = UIColor.FoodyFlow.darkOrange.cgColor
    addRecipe.setImage(UIImage(systemName: "plus"), for: .normal)
    addRecipe.imageView?.tintColor = .white
    addRecipe.addTarget(self, action: #selector(addRecipeInDB), for: .touchUpInside)
        
    }
    
    @objc func addRecipeInDB() {
        verifyUser { result  in
            
            switch result {
            case .success:
            
                let addRecipeVC = AddRecipeViewController(
                    nibName: "AddRecipeViewController",
                    bundle: nil)
            
                self.navigationController!.pushViewController(addRecipeVC, animated: true)
            case .failure:
                HandleResult.signOutFailed.messageHUD
            }
        }
        
    }
    
    func verifyUser( completion: @escaping (Result<String, Error>) -> Void ) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
        if user != nil {
                print("\(String(describing: user?.uid))")
                completion(.success("create"))
                } else {
                        self.present( LoginViewController(), animated: true )
                        completion(.failure(AuthManager.AuthError.unknownError))
                    }
        }
    }
// MARK: - Expandable tableView
}

extension PersonalLikeREcipeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened == true {
            return tableViewData[section].sectionData.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            guard let cell = personalRecipeTableView.dequeueReusableCell(
                withIdentifier: "personalrecipeTitleTableViewCell") as?
                PersonalTitleTableViewCell else { return UITableViewCell() }
            
            let attributedString1 = NSMutableAttributedString(string: "|   ", attributes: attrs1)

            let attributedString2 = NSMutableAttributedString(string: "\(tableViewData[indexPath.section].title)", attributes: attrs2)

            attributedString1.append(attributedString2)
            
            cell.textLabel?.attributedText = attributedString1
            
            return cell
        } else {
            if indexPath.section ==  0 {
            guard let cell = personalRecipeTableView.dequeueReusableCell(
                withIdentifier: "personalrecipeTableViewCell") as?
                PersonalRecipeTableViewCell else { return UITableViewCell() }
            
//            cell.textLabel?.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
            
//            cell.backgroundColor = .systemBlue
                return cell

            } else {
                
                guard let cell = personalRecipeTableView.dequeueReusableCell(
                    withIdentifier: "presonalLikeTableViewCell") as?
                    PresonalLikeTableViewCell else { return UITableViewCell() }
                
//                cell.textLabel?.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
                
//                cell.backgroundColor = .systemYellow

                return cell
            }
     
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
        if tableViewData[indexPath.section].opened {
            tableViewData[indexPath.section].opened = false
            let sections = IndexSet.init(integer: indexPath.section)
            personalRecipeTableView.reloadSections(sections, with: .fade) // play around with this
            
        } else {
            tableViewData[indexPath.section].opened = true
            let sections = IndexSet.init(integer: indexPath.section)
            personalRecipeTableView.reloadSections(sections, with: .fade)

        }
    }
    }
}
