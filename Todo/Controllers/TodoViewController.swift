//
//  ViewController.swift
//  Todo
//
//  Created by 吴启德 on 6/5/18.
//  Copyright © 2018 吴启德. All rights reserved.
//

import UIKit
import RealmSwift

class TodoViewController: UITableViewController {
    
    let realm  = try! Realm()
    
    var toDoItems: Results<Item>?
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }

    //let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
       
         loadItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
           // tableCell.textLabel?.text = toDoItems?[indexPath.row].title
        
        if let item = toDoItems?[indexPath.row] {
             tableCell.textLabel?.text = item.title
             tableCell.accessoryType = item.done ? .checkmark : .none
        }else{
            tableCell.textLabel?.text = "No Item added"
        }
        
        return tableCell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        //toDoItems?[indexPath.row].done  = !toDoItems?[indexPath.row].done

        //self.saveItems()
        
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
                
            }catch{
                print("\(error)")
            }
            
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add todo item", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            
            if let currentCat = self.selectedCategory {
                do{
                    try self.realm.write {
                        let item = Item()
                            item.title = textField.text!
                            item.createdDate = Date()
                        currentCat.items.append(item)
                    }
                }catch{
                    print("\(error)")
                }
                
            }
            
            self.tableView.reloadData()

            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new item"
            textField = alertTextField
        }
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    func loadItems(){
        toDoItems =  selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()

    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
}

extension TodoViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "createdDate", ascending: true)
        
        tableView.reloadData()
        
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//
//        request.sortDescriptors = [sortDescriptor]
//        loadItems(with: request, predicate: predicate)
    }
}

