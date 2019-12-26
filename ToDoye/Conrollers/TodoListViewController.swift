//
//  ViewController.swift
//  ToDoye
//
//  Created by Артём Шишкин on 22.11.2019.
//  Copyright © 2019 Артём Шишкин. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    
    var todoItems: Results<Item>?
    
    var selectedCategory: Category? {
        didSet{
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
         
         if let colourHex = selectedCategory?.color {
             title = selectedCategory!.name
             guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.")
             }
             if let navBarColour = UIColor(hexString: colourHex) {
                 //Original setting: navBar.barTintColor = UIColor(hexString: colourHex)
                 //Revised for iOS13 w/ Prefer Large Titles setting:
                  if #available(iOS 13.0, *) {
                        let appearance = UINavigationBarAppearance().self
                                        
                        appearance.backgroundColor = navBarColour
                        appearance.largeTitleTextAttributes = [
                            NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
                     
                        navBar.standardAppearance = appearance
                        navBar.compactAppearance = appearance
                        navBar.scrollEdgeAppearance = appearance
                        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
                                        
                    } else {
                        navBar.barTintColor = navBarColour
                        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
                        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
                    }
                 searchBar.barTintColor = navBarColour
             }
         }
     }
    
    //MARK: - tableView #1
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        }
        
        return cell
    }
    
    //MARK: - tableView delegate methods
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let item = todoItems?[indexPath.row]{
            do {
                try realm.write {
//                    realm.delete(item)
                    item.done = !item.done
                }
                }catch{
                    print("Error saving item's status, \(error)")
            }
        }
        tableView.reloadData()
        
        self.tableView.reloadData()
        
    }
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoye item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreate = Date()
                        currentCategory.items.append(newItem)
                        
                    }
                } catch{
                    print("Error saving new items, \(error)")
                }
                
            }
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil )
    }
    
    //MARK: - Model Manipulation Methods
    

    func loadData() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
        //MARK: - delete items
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.todoItems?[indexPath.row]{
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

//MARK: - SearchBar Methods

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
    }


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }


        }
    }
    
}

    
