//
//  Item.swift
//  Todoey
//
//  Created by Robert Liebert on 5/28/19.
//  Copyright © 2019 RobertLiebert. All rights reserved.
//

import Foundation

class Item : Codable {
    var text: String = "New Item"
    var checked: Bool = false
    
    init(_ text: String, checked: Bool) {
        self.text = text
        self.checked = checked
    }
}
