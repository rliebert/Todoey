//
//  ViewController.swift
//  Todoey
//
//  Created by Robert Liebert on 5/26/19.
//  Copyright © 2019 RobertLiebert. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    //var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    //let defaults = UserDefaults.standard
    
    //@IBOutlet weak var todoCellLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        itemArray.append(Item("Find Mike", checked: false))
//        itemArray.append(Item("Buy Eggos", checked: false))
//        itemArray.append(Item("Destroy Demogorgon", checked: false))
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        loadItems()
        
    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].text
        cell.accessoryType = itemArray[indexPath.row].checked ? .checkmark : .none
        return cell
    }
    
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // When cell is touched, give a checkmark if it was unchecked, and uncheck it if it was checked
        itemArray[indexPath.row].checked.toggle()

        saveItems()
        
        // Add a nice UI behavior where cell is highlighted and unhighlighted while it is checked (i.e. cell doesn't stay highlighted)
        tableView.deselectRow(at: indexPath, animated: true)
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
            //print(newTodoTextField.text!)
            if newTodoTextField.text?.isEmpty == false {
                self.itemArray.append(Item(newTodoTextField.text!, checked: false))
//                self.defaults.set(self.itemArray, forKey: "TodoListArray")
                self.saveItems()
            }
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
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }

}

