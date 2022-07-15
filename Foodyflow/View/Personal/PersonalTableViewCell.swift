//
//  PersonalTableViewCell.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 6/21/22.
//

import UIKit


protocol SelectCellDelegate: AnyObject {
    
    func didDeleteTap(indexPathRow: IndexPath)
    
    func didChangeName(indexPathRow: IndexPath)
    
}

class PersonalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var refreigeName: UILabel!
    
    @IBOutlet weak var refreigeImage: UIImageView!
    
    @IBOutlet weak var refrigeReName: UIButton!
    @IBOutlet weak var refrigeTrash: UIButton!
    
    var indexPath: IndexPath!
    
    weak var delegate: SelectCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        refrigeReName.addTarget(self, action: #selector(reFrigeRename), for: .touchUpInside)
        refrigeTrash.addTarget(self, action: #selector(refrigeTotrash), for: .touchUpInside)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func reFrigeRename() {
        delegate?.didChangeName(indexPathRow: indexPath)
    }
    
    @objc func refrigeTotrash() {
        delegate?.didDeleteTap(indexPathRow: indexPath)
    }
    
}
