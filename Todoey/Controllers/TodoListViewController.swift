//
//  ViewController.swift
//  Todoey
//
//  Created by Mykyta Havrylenko on 26.07.2022.
//

import UIKit
import RealmSwift
import DynamicColor

class TodoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()

    var items: Results<Item>?
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 70.0
        tableView.separatorStyle = .none
        
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let selectedCategory = selectedCategory
        else { return }
        
        guard let navigationBar = navigationController?.navigationBar
        else { fatalError("Navigation Bar does not exist.") }
        
        title = selectedCategory.name
        
        DispatchQueue.main.async {
            let categoryColor = UIColor(hexString: selectedCategory.backgroundColor)
            let textAdjustableColor = categoryColor.isLight() ? UIColor.black : UIColor.white
            
            // View
            self.view.backgroundColor = categoryColor.darkened(amount: 0.1)
            
            // Navigation Bar
            navigationBar.tintColor = textAdjustableColor
            navigationBar.barTintColor = categoryColor.darkened(amount: 0.3)
            navigationBar.backgroundColor = categoryColor.darkened(amount: 0.1)
            navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: textAdjustableColor
            ]
        }

        // Search Bar
        searchBar.placeholder = "Search"
        searchBar.searchTextField.backgroundColor = .white
        searchBar.tintColor = .black
    }
    
    
    //MARK: - Model Manipulation Methods
    func loadItems() {
        
        items = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.items?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
            } catch {
                print("Error deleting item: \(error)")
            }
        }
    }
    
}
    
//MARK: - TableView DataSource methods
extension TodoListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = items?[indexPath.row] {
            
            let cellColor = DynamicColor(hexString: selectedCategory!.backgroundColor).darkened(amount: CGFloat(indexPath.row) / CGFloat(2 * items!.count))
            
            // Text Label
            cell.textLabel!.text = item.title
            cell.textLabel!.textColor = cellColor.isLight() ? .black : .white
            
            // Background + Other
            cell.backgroundColor = cellColor
            cell.selectionStyle = .none
            
            // Accessory Type
            cell.accessoryType = item.isDone ? .checkmark : .none
        } else {
            cell.textLabel!.text = "No items added yet"
        }
        
        return cell
    }
}
    
//MARK: - TableView Delegate methods
extension TodoListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Save data
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    item.isDone = !item.isDone
                    
                    // To delete an Item
                    // realm.delete(item)
                }
            } catch {
                print("Error updating isDone: \(error)")
            }
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
}

//MARK: - UISearchBar

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            loadItems()

        } else {
            items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
        }
    }
    
}


// MARK: - IBActions
extension TodoListViewController {

    // Add Button on the Navigation Bar
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            let itemName = textField.text!
            
            if let currentCategory = self.selectedCategory {
                // Save data
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = itemName
                        newItem.dateCreated = Date.now
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving context: \(error)")
                }
            }
            
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

