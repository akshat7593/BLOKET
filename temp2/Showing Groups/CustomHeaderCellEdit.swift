//
//  CustomHeaderCellEdit.swift
//  temp2
//
//  Created by Akshat Agrawal on 10/04/19.
//  Copyright © 2019 Akshat Agrawal. All rights reserved.
//

import UIKit

class CustomHeaderCellEdit: UITableViewCell {
    
    var link: editGroupTableViewController?
    //var show_grp: showGroupsTableViewController?
    
    
    let show_grp = showGroupsTableViewController()
    
    @IBOutlet weak var AddBtn: UIButton!
    @IBOutlet weak var DoneBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func AddAction(_ sender: UIButton) {
        link?.addMore(button: AddBtn)
        
    }
    
    @IBAction func DoneAction(_ sender: UIButton) {
        print("done of group")
        show_grp.viewDidLoad()
        show_grp.handleExpandClose()
        
        //show_grp?.handleExpandClose()
        link?.doneGroup(button: DoneBtn)
        
        //self.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
