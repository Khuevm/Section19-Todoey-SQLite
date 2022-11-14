//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    // MARK: - IBOutlet
    @IBOutlet var searchBar: UISearchBar!
    
    // MARK: - Variable
    var items: [Item] = []
    var categoryID = 0
    var selectedCategory: Category? {
        // didSet dc gọi ngay khi biến có giá trị
        didSet {
            categoryID = (selectedCategory?.id)!
            items = DBController.shared.getItems(at: categoryID)
        }
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
    }
    
    // MARK: - IBAction
    @IBAction func addButtonDidTap(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            //What will happen if user tap the Add Item Button
            if textField.text?.trimmingCharacters(in: .whitespaces) != "" {
                //Create in CRUD
                let title = textField.text!
                let isDone = 0
                let parentCategory = self.categoryID
                let newItem = Item(title: title, isDone: isDone, categoryID: parentCategory)
                
                newItem.save()
                self.loadItems()
            }
        }

        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item..."
            textField = alertTextField
        }

        alert.addAction(action)
        present(alert, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentItem = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)

        cell.textLabel?.text = currentItem.title
        cell.accessoryType = currentItem.isDone == 1 ? .checkmark : .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //Delete in CRUD
            let currentItem = items[indexPath.row]
            currentItem.delete()
            
            loadItems()
        }
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentItem = items[indexPath.row]
        
        currentItem.update()
        loadItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Helper
    func loadItems(){
        items = DBController.shared.getItems(at: categoryID)
        tableView.reloadData()
    }
}

// MARK: - UISearchBarDelegate
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            items = DBController.shared.getItems(at: categoryID)
        } else {
            items = DBController.shared.getItems(at: categoryID, contains: searchBar.text!)
            tableView.reloadData()
        }
    }
}
