//
//  TableViewCell.swift
//  temp2
//
//  Created by Akshat Agrawal on 19/02/19.
//  Copyright © 2019 Akshat Agrawal. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var number: UILabel!
    
    @IBOutlet weak var delete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
