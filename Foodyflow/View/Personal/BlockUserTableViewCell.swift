//
//  BlockUserTableViewCell.swift
//  Foodyflow
//
//  Created by 曹珮綺 on 7/12/22.
//

import UIKit

protocol UnblockUserCellDelegate: AnyObject {
    
    func didunblockTap(indexPathRow: IndexPath)
    
}

class BlockUserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var unBlockbtn: UIButton!
    
    var indexPath: IndexPath!
    
    weak var delegate: UnblockUserCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        unBlockbtn.addTarget(self, action: #selector(unblockUser), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func unblockUser(){
        delegate?.didunblockTap(indexPathRow: indexPath)
    }
    
}
