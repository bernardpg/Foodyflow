//
//  RefrigeCatTableViewCell.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/17/22.
//

import UIKit

typealias DidSelectClosure = (( _ tableIndex: Int?, _ collectionIndex: Int?) -> Void )

class RefrigeCatTableViewCell: UITableViewCell {
    
    let identifier = "RefrigeCatTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "RefrigeCatTableViewCell",
                     bundle: nil)
    }
    
    @IBOutlet var inCatCollectionView: UICollectionView!
    @IBOutlet weak var cateFood: UILabel!
    
    var foodsInfo: [FoodInfo] = []
    
    var index: Int?
    var didSelectClosure: DidSelectClosure?

    override func awakeFromNib() {
        super.awakeFromNib()
        inCatCollectionView.register(InCatCollectionViewCell.nib(),
        forCellWithReuseIdentifier: InCatCollectionViewCell.identifier)
        inCatCollectionView.delegate = self
        inCatCollectionView.dataSource = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func configure(with models: [FoodInfo]) {
        self.foodsInfo = models
        inCatCollectionView.reloadData()
    }
}
extension RefrigeCatTableViewCell: UICollectionViewDelegate,
                                   UICollectionViewDataSource,
                                   UICollectionViewDelegateFlowLayout {
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    foodsInfo.count
    
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InCatCollectionViewCell.identifier,
        for: indexPath) as? InCatCollectionViewCell
    guard let cell = cell else { return UICollectionViewCell() }
//    cell.myLabel.text = models[0].foodID[indexPath.row]
    cell.layer.cornerRadius = 20
    cell.layer.borderWidth = 0.5
    cell.backgroundColor = UIColor.FoodyFlow.lightOrange
    cell.myImageView.lkCornerRadius = 20 
    cell.configute(with: foodsInfo[indexPath.row])
    return cell
    
}
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 170, height: 170 )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        didSelectClosure?(index, indexPath.row)
     }
}
