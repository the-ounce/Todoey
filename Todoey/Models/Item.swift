//
//  Item.swift
//  Todoey
//
//  Created by Mykyta Havrylenko on 30.07.2022.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @Persisted var title: String
    @Persisted var isDone: Bool = false
    @Persisted var dateCreated: Date
    
    @Persisted var backgroundColor: String
    
    @Persisted(originProperty: "items") var parentCategory: LinkingObjects<Category>
}
