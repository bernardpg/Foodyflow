//
//  PersonalTitleTableViewCell.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 7/7/22.
//

import UIKit

class PersonalTitleTableViewCell: UITableViewCell {
    
    let identifier = "personalrecipeTitleTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "personalrecipeTitleTableViewCell",
                     bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
