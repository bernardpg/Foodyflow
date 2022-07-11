//
//  PersonalRecipeTableViewCell.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 7/7/22.
//

import UIKit

class PersonalRecipeTableViewCell: UITableViewCell {
    
    let identifier = "personalrecipeTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "personalrecipeTableViewCell",
                     bundle: nil)
    }
    
    @IBOutlet weak var personalRecipeImage: UIImageView!
    
    @IBOutlet weak var personalRecipeName: UILabel!
    
    @IBOutlet weak var personalEditRecipe: UIButton!
    
    @IBOutlet weak var personalDeleteRecipe: UIButton!
    
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
