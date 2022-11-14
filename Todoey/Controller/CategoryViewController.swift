//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Khue on 20/10/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit

class CategoryViewController: UITableViewController {
    // MARK: - Variable
    var categories: [Category] = []
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        categories = DBController.shared.getCategories()
    }
    
    // MARK: - IBAction
    @IBAction func addButtonDidTap(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { action in
            if textField.text?.trimmingCharacters(in: .whitespaces) != "" {
                let newCategory = Category(name: textField.text!)
                
                newCategory.save()
                self.loadCategories()
            }
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new category..."
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let currentCategory = categories[indexPath.row]
            currentCategory.delete()
            loadCategories()
        }
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    // MARK: - Helper
    func loadCategories() {
        categories = DBController.shared.getCategories()
        tableView.reloadData()
    }
    
}
