//
//  BlockedExpandableNames.swift
//  temp2
//
//  Created by Akshat Agrawal on 09/04/19.
//  Copyright © 2019 Akshat Agrawal. All rights reserved.
//

import Foundation
import Contacts

struct BlockedExpandableNames {
    var isExpanded: Bool
    var name: [FavoritableContacts]
}

struct FavoritableContacts {
    let name: String?
    let number: String?
    var hasFavorited: Bool
}
