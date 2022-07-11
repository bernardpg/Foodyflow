//
//  RecipeTableViewCell.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 7/1/22.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeImage: UIImageView!
    
    @IBOutlet weak var recipeName: UILabel!
    
    let identifier = "recipeTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "recipeTableViewCell",
                     bundle: nil)
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        recipeImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
