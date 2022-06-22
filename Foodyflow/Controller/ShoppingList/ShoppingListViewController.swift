//
//  ShoppingListViewController.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/20/22.
//

import UIKit

class ShoppingListViewController: UIViewController {
    private var shoppingListCollectionView: UICollectionView!
    private var tapButton = UIButton()
    
    var tabIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        shoppingListCollectionView.backgroundColor = .systemPink
        shoppingListCollectionView.layoutIfNeeded() // jordan
        tapButton.layer.cornerRadius = (tapButton.frame.height)/2
    }
    
    func setUI() {
        
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10) // section與section之間的距離(如果只有一個section，可以想像成frame)
        layout.itemSize = CGSize(width: (self.view.frame.size.width - 30) / 2, height: 120) // cell的寬、高
        layout.minimumLineSpacing = CGFloat(integerLiteral: 10) // 滑動方向為「垂直」的話即「上下」的間距;滑動方向為「平行」則為「左右」的間距
        layout.minimumInteritemSpacing = CGFloat(integerLiteral: 10) // 滑動方向為「垂直」的話即「左右」的間距;滑動方向為「平行」則為「上下」的間距
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical //UICollectionViewScrollDirection.vertical
                
        shoppingListCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), collectionViewLayout: layout)
        shoppingListCollectionView.dataSource = self
        shoppingListCollectionView.delegate = self
        shoppingListCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        shoppingListCollectionView.backgroundColor = UIColor.black
        view.addSubview(shoppingListCollectionView)
        shoppingListCollectionView.translatesAutoresizingMaskIntoConstraints = false
        shoppingListCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        shoppingListCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        shoppingListCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        shoppingListCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                            constant: 0).isActive = true
        
        shoppingListCollectionView.addSubview(tapButton)
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

}
extension ShoppingListViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 26
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor.orange : UIColor.brown
            return cell
        }
        
        // MARK: - Delegate
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            print("row: \(indexPath.row)")
        }
}
