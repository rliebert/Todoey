//
//  ViewController.swift
//  Todoey
//
//  Created by Robert Liebert on 5/26/19.
//  Copyright © 2019 RobertLiebert. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    let realm = try! Realm()
    var todoItems: Results<Item>?
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //let defaults = UserDefaults.standard
    
    //@IBOutlet weak var todoCellLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadItems()
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.text
            cell.accessoryType = item.checked ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.checked.toggle()
                }
            } catch {
                print("Error saving checked status: \(error)")
            }
        }
        //tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
//    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        tableView.cellForRow(at: indexPath)?.accessoryType = .none
//    }
    
    //MARK - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var newTodoTextField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the "Add Item" button on this alert
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.text = newTodoTextField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items: \(error)")
                }
            }
            
            self.tableView.reloadData()
            
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            newTodoTextField = alertTextField
        }
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK - Model Manipulation Methods
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "text", ascending: true)
        
        tableView.reloadData()
    }

}

//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("text CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        if searchBar.text?.count == 0 {
//            loadItems()
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//
//        }
//    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        loadItems()
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
        
    }
    
    
    
}
