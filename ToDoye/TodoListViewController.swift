//
//  ViewController.swift
//  ToDoye
//
//  Created by Артём Шишкин on 22.11.2019.
//  Copyright © 2019 Артём Шишкин. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Find Richar", "Do tatoo", "Bue milk"]
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
    }
    
    
    //MARK: - tableView #1
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK: - tableView delegate methods
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
    }
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoye item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            if let item = textField.text {
                
                self.itemArray.append(item)
                
                self.defaults.set(self.itemArray, forKey: "TodoListArray")
                 
                self.tableView.reloadData()
                
                
            }
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil )
    }
    
    
    

    

}



    
