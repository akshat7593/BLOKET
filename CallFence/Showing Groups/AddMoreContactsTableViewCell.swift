//
//  ContactCell.swift
//  ContactsLBTA
//
//  Created by Brian Voong on 11/20/17.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
import Contacts
import SQLite
class AddMoreContactsTableViewCell: UITableViewCell {
    
    var link: AddMoreContactsController?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        print("In ContactCell")
        let starButton = UIButton(type: .system)
        starButton.setImage(#imageLiteral(resourceName: "fav_star"), for: .normal)
        starButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        starButton.tintColor = .red
        starButton.addTarget(self, action: #selector(handleMarkAsFavorite), for: .touchUpInside)
        
        accessoryView = starButton
    }
    
    @objc private func handleMarkAsFavorite() {
        //        print("Marking as favorite")
        link?.someMethodIWantToCall(cell: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
