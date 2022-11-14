//
//  Item.swift
//  Todoey
//
//  Created by Khue on 06/11/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct Item {
    var id: Int?
    var title: String
    var isDone: Int //0: False, 1: True
    var categoryID: Int
    
    //Create in CRUD
    func save(){
        let query = "INSERT INTO Item(title, isDone, categoryID)  VALUES ('\(self.title)', \(self.isDone), \(self.categoryID))"
        _ = DBController.shared.executeUpdate(query: query)
    }
    
    //Update in CRUD
    func update() {
        let newDone = isDone == 0 ? 1 : 0
        let query = "UPDATE Item SET isDone = \(newDone) WHERE id = \(self.id!)"
        let success = DBController.shared.executeUpdate(query: query)
        print(success)
    }
    
    //Delete in CRUD
    func delete() {
        let query = "DELETE FROM Item WHERE id = \(self.id!)"
        _ = DBController.shared.executeUpdate(query: query)
    }
}
