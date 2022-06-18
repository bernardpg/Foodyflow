//
//  InCatCollectionViewCell.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/17/22.
//

import UIKit

class InCatCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var myLabel: UILabel!
    
    static let identifier = "InCatCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "InCatCollectionViewCell",
                     bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configute(with model: Model) {
        self.myLabel.text = model.text
    }

}
