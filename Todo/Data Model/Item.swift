//
//  Item.swift
//  Todo
//
//  Created by 吴启德 on 6/13/18.
//  Copyright © 2018 吴启德. All rights reserved.
//

import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var createdDate: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
