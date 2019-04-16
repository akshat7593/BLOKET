//
//  IndividualCustomHeader.swift
//  temp2
//
//  Created by Akshat Agrawal on 15/04/19.
//  Copyright © 2019 Akshat Agrawal. All rights reserved.
//

import UIKit

class IndividualCustomHeader: UITableViewCell {
    
    var link: contactsTableViewController?
    
    @IBOutlet weak var AddBlack: UIButton!
    @IBOutlet weak var AddWhite: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func AddBlackList(_ sender: UIButton) {
        link?.AddtoBlackList(button: AddBlack)
    }
    @IBAction func AddWhiteList(_ sender: UIButton) {
        link?.AddtoWhiteList(button: AddWhite)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
