//
//  DBController.swift
//  Todoey
//
//  Created by Khue on 06/11/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import FMDB

private let DatabaseName = "Todoey.db"

class DBController {
    static let shared = DBController()
    var database: FMDatabase!
    
    init(){
        self.initDatabase(dbName: DatabaseName)
    }
    
    func getCategories() -> [Category] {
        var categories = [Category]()
        database.open()
        do {
            let resultset = try DBController.shared.database.executeQuery("SELECT * FROM Category", values: nil)
            
            while resultset.next() {
                let id = Int(resultset.int(forColumn: "id"))
                let name = resultset.string(forColumn: "name") ?? ""
                categories.append(Category(id: id, name: name))
            }
        } catch {
            print("Error getting data \(error)")
        }
        database.close()
        return categories
    }
    
    //Read in CRUD
    func getItems(at categoryID: Int) -> [Item] {
        var items = [Item]()
        database.open()
        do {
            let resultset = try DBController.shared.database.executeQuery("SELECT * FROM Item WHERE categoryID = \(categoryID)", values: nil)
            
            while resultset.next() {
                let id = Int(resultset.int(forColumn: "id"))
                let title = resultset.string(forColumn: "title") ?? ""
                let isDone = Int(resultset.int(forColumn: "isDone"))
                let categoryID = Int(resultset.int(forColumn: "categoryID"))
                
                let item = Item(id: id, title: title, isDone: isDone, categoryID: categoryID)
                items.append(item)
            }
        } catch {
            print("Error getting data \(error)")
        }
        database.close()
        return items
    }
    
    func getItems(at categoryID: Int, contains text: String) -> [Item] {
        var items = [Item]()
        database.open()
        do {
            //%%: string always starts with any and ends with any
            let resultset = try DBController.shared.database.executeQuery("SELECT * FROM Item WHERE categoryID = \(categoryID) AND title like '%\(text)%'", values: nil)
            
            while resultset.next() {
                let id = Int(resultset.int(forColumn: "id"))
                let title = resultset.string(forColumn: "title") ?? ""
                let isDone = Int(resultset.int(forColumn: "isDone"))
                let categoryID = Int(resultset.int(forColumn: "categoryID"))
                
                let item = Item(id: id, title: title, isDone: isDone, categoryID: categoryID)
                items.append(item)
            }
            
            items.sort {
                $0.title < $1.title
            }
        } catch {
            print("Error getting data \(error)")
        }
        database.close()
        return items
    }
}

extension DBController {
    // MARK: - Get path of our db
    func initDatabase(dbName: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Document Directory not found")
            return
        }
        let databaseFilePath = documentDirectory.appendingPathComponent(dbName).path
        
        //Nếu db ko tồn tại
        if !FileManager.default.fileExists(atPath: databaseFilePath) {
            let bundle = Bundle.main.resourceURL
            let file = bundle?.appendingPathComponent(dbName)
            
            do {
                try FileManager.default.copyItem(atPath: file!.path, toPath: databaseFilePath)
            } catch {
                print("Error copyDatabase: \(error)")
            }
        }
        
        database = FMDatabase.init(path: databaseFilePath)
    }
    
    func executeUpdate(query: String) -> Bool {
        database.open()
        let success = database.executeStatements(query)
        database.close()
        return success
    }
    
}
