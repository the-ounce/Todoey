//
//  ViewController.swift
//  Todoey
//
//  Created by Mykyta Havrylenko on 26.07.2022.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemsArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()

    }
    
}
    
//MARK: - TableView DataSource methods
extension TodoListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        
        cell.textLabel!.text = itemsArray[indexPath.row].name
        
        cell.accessoryType = itemsArray[indexPath.row].isChecked ? .checkmark : .none
        
        return cell
    }
}
    
//MARK: - TableView Delegate methods
extension TodoListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        itemsArray[indexPath.row].isChecked = !itemsArray[indexPath.row].isChecked
        
        // Save data
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - IBActions
extension TodoListViewController {

    // Add Buttom on the Navigation Bar
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            let itemName = textField.text!
            
            let newItem = Item(context: self.context)
            newItem.name = itemName
            newItem.isChecked = false
            
            self.itemsArray.append(newItem)
            
            // Save data
            self.saveItems()
        }
        
        alert.addTextField { itemTextField in
            itemTextField.placeholder = "Name your task"
            // Assign to the method's global variable
            textField = itemTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}


//MARK: - Model Manipulation Methods

extension TodoListViewController {
    
    func saveItems() {
    
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        
        tableView.reloadData()
    }

    func loadData( ) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            itemsArray = try context.fetch(request)
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
}
