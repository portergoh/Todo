//
//  ViewController.swift
//  Todo
//
//  Created by 吴启德 on 6/5/18.
//  Copyright © 2018 吴启德. All rights reserved.
//

import UIKit
import CoreData

class TodoViewController: UITableViewController {
    
    var itemArray = [Item]()
    var selectedCategory: Category? {
        didSet{
              loadItems()
        }
    }

    //let defaults = UserDefaults.standard
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        
      // navigationItem.title = "Todo"
        
        
        let dataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        print("\(dataPath)")
        
//        if let myDefaults =  defaults.array(forKey: "TodoArrayList") {
//           itemArray = myDefaults as! [Item]
//        }
        
         //loadItems()
       
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
            tableCell.textLabel?.text = itemArray[indexPath.row].title
        
        let item = itemArray[indexPath.row]
        tableCell.textLabel?.text = item.title
        
        tableCell.accessoryType = item.done ? .checkmark : .none
        
        return tableCell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
       
        itemArray[indexPath.row].done  = !itemArray[indexPath.row].done

        self.saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add todo item", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            let item = Item(context: self.context)
                item.title = textField.text!
                item.done = false
                item.parentCategory = self.selectedCategory
            
            self.itemArray.append(item)
           // self.defaults.set(self.itemArray, forKey: "TodoArrayList")

            self.saveItems()
            //print(textField.text!)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new item"
            textField = alertTextField
        }
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        do {
         
            let catPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
            
            if let predicate = predicate {
               let combinePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate,catPredicate])
            
                request.predicate = combinePredicate
            }else{
                request.predicate = catPredicate
            }
            
            itemArray =  try context.fetch(request)
            
            
        }catch{
            print("\(error)")
        }
        
        tableView.reloadData()

    }
    
    func saveItems(){
        do {
            try context.save()
        }catch {
            print("\(error)")
        }
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
}

extension TodoViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        loadItems(with: request, predicate: predicate)
    }
}

