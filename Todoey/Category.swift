//
//  Category.swift
//  Todoey
//
//  Created by Robert Liebert on 5/29/19.
//  Copyright © 2019 RobertLiebert. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}

