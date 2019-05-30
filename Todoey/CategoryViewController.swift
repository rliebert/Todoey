//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Robert Liebert on 5/29/19.
//  Copyright © 2019 RobertLiebert. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    var categories : Results<Category>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }

    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        return cell
    }
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let destinationVC = segue.destination as! TodoListViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categories?[indexPath.row]
            }
        }
    }
    
    // Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var newCategoryTextField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category()
            if newCategoryTextField.text?.isEmpty == false {
                newCategory.name = newCategoryTextField.text!
                self.save(category: newCategory)
            }
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new category"
            newCategoryTextField = alertTextField
        }
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Data manipulation Methods
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving categories: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {

        categories = realm.objects(Category.self)
        
        //        do {
//            categories = try context.fetch(request)
//        } catch {
//            print("Error fetching categories: \(error)")
//        }
        tableView.reloadData()
    }
    

    
}
