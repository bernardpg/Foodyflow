//
//  PersonalRecipeTableViewCell.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 7/7/22.
//

import UIKit


protocol SelectPersonalRecipeCellDelegate: AnyObject {
    
    func didDeleteRecipe(indexPathRow: IndexPath)
    
    func didEditRecipe(indexPathRow: IndexPath)

}

class PersonalRecipeTableViewCell: UITableViewCell {
    
    let identifier = "personalrecipeTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "personalrecipeTableViewCell",
                     bundle: nil)
    }
    
    var indexPath: IndexPath!
    
    weak var delegate: SelectPersonalRecipeCellDelegate?
    
    @IBOutlet weak var personalRecipeImage: UIImageView!
    
    @IBOutlet weak var personalRecipeName: UILabel!
    
    @IBOutlet weak var personalEditRecipe: UIButton!
    
    @IBOutlet weak var personalDeleteRecipe: UIButton!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        personalEditRecipe.addTarget(self, action: #selector(editRecipe), for: .touchUpInside)
        personalDeleteRecipe.addTarget(self, action: #selector(deleteRecipe), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @objc func editRecipe() {
        delegate?.didEditRecipe(indexPathRow: indexPath)
        
    }
    
    @objc func deleteRecipe() {
        delegate?.didDeleteRecipe(indexPathRow: indexPath)
    }
    
}
