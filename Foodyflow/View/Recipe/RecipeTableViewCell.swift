//
//  RecipeTableViewCell.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 7/1/22.
//

import UIKit

protocol RecipeLikeDelegate: AnyObject{
    
    func didLikeTap(indexPathRow:IndexPath)
}

class RecipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeImage: UIImageView!
    
    @IBOutlet weak var recipeName: UILabel!
    
    @IBOutlet weak var recipeUserName: UILabel!
    
    var indexPath: IndexPath!
    
    @IBOutlet weak var likeRecipeBtn: UIButton!
    
    weak var delegate: RecipeLikeDelegate?
    
    let identifier = "recipeTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "recipeTableViewCell",
                     bundle: nil)
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        recipeImage.clipsToBounds = true
        likeRecipeBtn.addTarget(self, action: #selector(likeRecipe), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @objc func likeRecipe(){
        delegate?.didLikeTap(indexPathRow: indexPath)
    }
    
}
