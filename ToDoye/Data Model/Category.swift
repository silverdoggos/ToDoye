//
//  Category.swift
//  ToDoye
//
//  Created by Артём Шишкин on 04.12.2019.
//  Copyright © 2019 Артём Шишкин. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    let items = List<Item>()
    @objc dynamic var color: String = ""
}
