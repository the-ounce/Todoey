//
//  Category.swift
//  Todoey
//
//  Created by Mykyta Havrylenko on 30.07.2022.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @Persisted var name: String = ""
    
    // Inverse Relationship
    @Persisted var items = List<Item>()
}
