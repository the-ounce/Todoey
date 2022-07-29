//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mykyta Havrylenko on 29.07.2022.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoriesArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }

}

//MARK: - TableView Delegate

extension CategoryViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
     //   tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoriesArray[indexPath.row]
        }
        
    }
    
    
}


//MARK: - TableView Data Source Methods
extension CategoryViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = categoriesArray[indexPath.row].name
        cell.contentConfiguration = content
        
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
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text
            
            self.categoriesArray.append(newCategory)
            
            self.saveCategories()
        }
        
        alert.addAction(alertAction)
        
        present(alert, animated: true)
    }
}


//MARK: - Data Manipulations Methods
extension CategoryViewController {
    
    func saveCategories() {
        
        do {
            try context.save()
        } catch {
            print("Error: \(error)")
        }
       
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categoriesArray = try context.fetch(request)
        } catch {
            print("Error fetching Data: \(error)")
        }
        
        tableView.reloadData()
        
    }
    
}
