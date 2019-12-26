//
//  Item.swift
//  ToDoye
//
//  Created by Артём Шишкин on 04.12.2019.
//  Copyright © 2019 Артём Шишкин. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreate: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
