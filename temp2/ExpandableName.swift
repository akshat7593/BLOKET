//
//  ExpandableNames.swift
//  ContactsLBTA
//
//  Created by Brian Voong on 11/17/17.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import Foundation
import Contacts

struct ExpandableNames {
    var isExpanded: Bool
    var names: [FavoritableContact]
}

struct FavoritableContact {
    let contact: CNContact
    let name: String?
    var hasFavorited: Bool
}


