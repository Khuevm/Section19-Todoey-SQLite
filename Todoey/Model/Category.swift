//
//  Category.swift
//  Todoey
//
//  Created by Khue on 06/11/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct Category {
    var id: Int?
    var name: String
    
    func save() {
        let query = "INSERT INTO Category(name)  VALUES ('\(self.name)')"
        _ = DBController.shared.executeUpdate(query: query)
    }
    
    func delete() {
        let query = "DELETE FROM Category WHERE id = \(self.id!)"
        _ = DBController.shared.executeUpdate(query: query)
    }
}


