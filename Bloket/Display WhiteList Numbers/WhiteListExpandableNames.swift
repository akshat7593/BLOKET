//
//  WhiteListExpandableNames.swift
//  temp2
//
//  Created by Akshat Agrawal on 15/04/19.
//  Copyright © 2019 Akshat Agrawal. All rights reserved.
//
import Foundation
import Contacts

struct WhiteListExpandableNames {
    var isExpanded: Bool
    var name: [WhiteListContacts]
}

struct WhiteListContacts {
    let name: String?
    let number: String?
    var hasFavorited: Bool
}

