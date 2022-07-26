//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mykyta Havrylenko on 29.07.2022.
//

import UIKit
import RealmSwift
import DynamicColor

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Rows of Table Views
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none

        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let navigationBar = navigationController?.navigationBar
        else { fatalError("Navigation Bar does not exist.") }
        
        DispatchQueue.main.async {
            let menuColor = UIColor(hexString: "90A4AF")
            
            // View
            self.view.backgroundColor = menuColor
            
            // Navigation Bar
            navigationBar.tintColor = .black
            navigationBar.barTintColor = menuColor.darkened(amount: 0.3)
            navigationBar.backgroundColor = menuColor
            navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.black
            ]
        }
    }
    
    //MARK: - Data Manipulations Methods
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error: \(error)")
        }
       
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    // Delete item from swipe
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryToDelete = self.categories?[indexPath.row] {
            
            do {
                try realm.write {
                    realm.delete(categoryToDelete)
                }
            } catch {
                print("Error with category deletion: \(error)")
            }
            
            // tableView.reloadData()
        }
    }
}

//MARK: - TableView Delegate

extension CategoryViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
}


//MARK: - TableView Data Source Methods
extension CategoryViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            
            let backgroudColor = DynamicColor(hexString: category.backgroundColor)
            
            cell.backgroundColor = backgroudColor

        // Content Config
            var content = cell.defaultContentConfiguration()
            // Text
            content.text = category.name
            content.textProperties.color = cell.backgroundColor!.isLight() ? .black : .white
            
            cell.contentConfiguration = content
        }
        
        return cell
    }
    
    
}

//MARK: - IBActions
extension CategoryViewController {
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: nil, preferredStyle: .alert)
        
        alert.addTextField { categoryTextField in
            categoryTextField.placeholder = "Name your category"
            
            textField = categoryTextField
        }
        
        let alertAction = UIAlertAction(title: "Add Category", style: .default) { action in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.backgroundColor = UIColor.random.toHexString()
            
            self.save(category: newCategory)
        }
        
        alert.addAction(alertAction)
        
        present(alert, animated: true)
    }
}
