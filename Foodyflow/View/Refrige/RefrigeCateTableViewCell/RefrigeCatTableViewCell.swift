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
    
    var models = [Model]()
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
    func configure(with models: [Model]) {
        self.models = models
        inCatCollectionView.reloadData()
    }
}
extension RefrigeCatTableViewCell: UICollectionViewDelegate,
                                   UICollectionViewDataSource,
                                   UICollectionViewDelegateFlowLayout {
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    models.count
    
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InCatCollectionViewCell.identifier,
        for: indexPath) as? InCatCollectionViewCell
    guard let cell = cell else { return UICollectionViewCell() }
    cell.backgroundColor = .systemPink
    cell.configute(with: models[indexPath.row])
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
