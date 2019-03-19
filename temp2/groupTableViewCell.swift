//
//  groupTableViewCell.swift
//  temp2
//
//  Created by Akshat Agrawal on 19/03/19.
//  Copyright © 2019 Akshat Agrawal. All rights reserved.
//

import UIKit

class groupTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var switchBtn: UISwitch!
    @IBOutlet weak var edit: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
