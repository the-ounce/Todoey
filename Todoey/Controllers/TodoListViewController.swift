//
//  ViewController.swift
//  Todoey
//
//  Created by Mykyta Havrylenko on 26.07.2022.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!

    var itemsArray = [Item]()
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.tintColor = UIColor.white
        }
        
        searchBar.delegate = self
    }
    
}
    
//MARK: - TableView DataSource methods
extension TodoListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        
        cell.textLabel!.text = itemsArray[indexPath.row].title
        
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

//MARK: - UISearchBar

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            loadItems()
            
        } else {
            let request: NSFetchRequest<Item> = Item.fetchRequest()
            
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadItems(with: request, predicate: predicate)
        }
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
            newItem.title = itemName
            newItem.isChecked = false
            newItem.parentCategory = self.selectedCategory
            
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

    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(),
                   predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        // If predicate has been specified
        if let additionalPredicate = predicate {
            
            // Creating Compound Predicate
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }

        
        do {
            itemsArray = try context.fetch(request)
        } catch {
            print("Error fetching data: \(error)")
        }
        
        tableView.reloadData()
    }
    
}
