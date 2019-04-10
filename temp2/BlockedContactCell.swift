//
//  BlockedContactCell.swift
//  temp2
//
//  Created by Akshat Agrawal on 09/04/19.
//  Copyright © 2019 Akshat Agrawal. All rights reserved.
//

import UIKit

class BlockedContactCell: UITableViewCell {
    
    var link: DisplayBlockedNumbers?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //print("In BlockedContactCell")
        let deleteButton = UIButton(type: .system)
        //starButton.setImage(#imageLiteral(resourceName: "fav_star"), for: .normal)
        deleteButton.setTitle("X", for: .normal)
        deleteButton.setTitleColor(.red, for: .normal)
        deleteButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        deleteButton.tintColor = .red
        deleteButton.addTarget(self, action: #selector(handleMarkAsFavorite), for: .touchUpInside)
        
        accessoryView = deleteButton
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @objc private func handleMarkAsFavorite() {
        //        print("Marking as favorite")
        link?.delete(cell: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
