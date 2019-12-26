//
//  CategoryViewController.swift
//  ToDoye
//
//  Created by Артём Шишкин on 28.11.2019.
//  Copyright © 2019 Артём Шишкин. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

 
class CategoryViewController: SwipeTableViewController{
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        tableView.separatorStyle = .none
        tableView.rowHeight = 80.0

    }
    
override func viewWillAppear(_ animated: Bool) {
    guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.")
    }
    
    if #available(iOS 13.0, *) {
        let appearance = UINavigationBarAppearance().self
                        
        appearance.backgroundColor = UIColor(hexString: "34C759")
        appearance.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: ContrastColorOf(UIColor(hexString: "34C759")!, returnFlat: true)]
     
        navBar.standardAppearance = appearance
        navBar.compactAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
        navBar.tintColor = ContrastColorOf(UIColor(hexString: "34C759")!, returnFlat: true)
                        
    } else {
        navBar.barTintColor = UIColor(hexString: "34C759")
        navBar.tintColor = ContrastColorOf(UIColor(hexString: "34C759")!, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(UIColor(hexString: "34C759")!, returnFlat: true)]
    }
}
    
   //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { 
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        
       if let category = categories?[indexPath.row] {
             guard let categoryColour = UIColor(hexString: category.color) else {fatalError()}
             cell.backgroundColor = categoryColour
             cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
         }
        
        return cell
    }
    
    //MARK: - TableView delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }

    //MARK: - Make a new Categories
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            
            let newCategory = Category()
            
            newCategory.color = UIColor.randomFlat().hexValue()
            newCategory.name = textField.text!
             
            self.save(category: newCategory)
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil )
    }
           
    
    //MARK: - data Manipulation Methods
    

    func save(category: Category){
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error with saving data to core data")
        }
    }
    
    func loadData() {
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - delete Data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.categories?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(item)
                }
            }catch {
                print("Error deleting category, \(error)")
            }
            
        }
    }
    
    

}


