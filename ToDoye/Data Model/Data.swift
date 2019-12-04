//
//  Data.swift
//  ToDoye
//
//  Created by Артём Шишкин on 04.12.2019.
//  Copyright © 2019 Артём Шишкин. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var  age: Int = 0
}
