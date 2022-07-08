//
//  PresonalLikeTableViewCell.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 7/8/22.
//

import UIKit

class PresonalLikeTableViewCell: UITableViewCell {
    
    let identifier = "presonalLikeTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "presonalLikeTableViewCell",
                     bundle: nil)
    }
    
    var like: Bool = false
    
    @IBOutlet weak var personalLikeRecipe: UIImageView!
    
    @IBOutlet weak var personalLikeBtn: UIButton!
    
    @IBOutlet weak var personalLikeRecipeName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        personalLikeBtn.addTarget(self, action: #selector(likeRecipe), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func likeRecipe() {
        
        if like {
            like = !like
            personalLikeBtn.setImage(UIImage(systemName: "heart"), for: .selected)

        }else {
            like = !like
            personalLikeBtn.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        }
        
        
        
    }
    
    
}
