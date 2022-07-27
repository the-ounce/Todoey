//
//  ViewController.swift
//  Todoey
//
//  Created by Mykyta Havrylenko on 26.07.2022.
//

import UIKit

class TodoListViewController: UITableViewController {

    var array = ["Meet the guy", "Buy eggs", "Send the declaration"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
    
//MARK: - TableView DataSource methods
extension TodoListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        
        cell.textLabel!.text = array[indexPath.row]
        
        return cell
    }
}
    
//MARK: - TableView Delegate methods
extension TodoListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)!
        
        if cell.accessoryType == .checkmark {
            cell.accessoryType = .none
        } else {
            cell.accessoryType = .checkmark
        }
        
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
            
            self.array.append(itemName)
            self.tableView.reloadData()
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
