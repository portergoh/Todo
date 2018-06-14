//
//  Category.swift
//  Todo
//
//  Created by 吴启德 on 6/13/18.
//  Copyright © 2018 吴启德. All rights reserved.
//

import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
    
}
