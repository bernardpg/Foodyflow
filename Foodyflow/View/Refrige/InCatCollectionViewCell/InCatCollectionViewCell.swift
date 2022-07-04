//
//  InCatCollectionViewCell.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/17/22.
//

import UIKit
import Kingfisher

class InCatCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var myLabel: UILabel!
    
    @IBOutlet weak var myImageView: UIImageView!
    static let identifier = "InCatCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "InCatCollectionViewCell",
                     bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configute(with model: FoodInfo) {
        self.myLabel.text = model.foodName
        
        if model.foodImages == "" {myImageView.image = UIImage(named: "imageDefault")} else{
            self.myImageView.kf.setImage(with: URL(string:model.foodImages ?? ""))}
    }

}
