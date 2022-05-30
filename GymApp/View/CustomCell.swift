//
//  CustomCell.swift
//  GymApp
//
//  Created by Caio Teodoro on 29/05/22.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectedBackgroundView?.backgroundColor = UIColor.tanColor
    }

}
