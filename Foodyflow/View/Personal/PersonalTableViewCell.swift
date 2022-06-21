//
//  PersonalTableViewCell.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/21/22.
//

import UIKit

class PersonalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var refreigeName: UILabel!
    
    @IBOutlet weak var refreigeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
