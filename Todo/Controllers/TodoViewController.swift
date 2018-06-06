//
//  ViewController.swift
//  Todo
//
//  Created by 吴启德 on 6/5/18.
//  Copyright © 2018 吴启德. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {
    
    var itemArray = [Item]()

    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       navigationItem.title = "Todo"
        let item1 = Item()
            item1.title = "Buy Toto"
        
        let item2 = Item()
            item2.title = "Buy Soap"
        
        itemArray.append(item1)
        itemArray.append(item2)
        
        if let myDefaults =  defaults.array(forKey: "Todo") {
           itemArray = myDefaults as! [Item]
        }
       
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
//        if item.done == false{
//            tableCell.accessoryType = .none
//        }else{
//            tableCell.accessoryType = .checkmark
//        }
        
        return tableCell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
       
        itemArray[indexPath.row].done  = !itemArray[indexPath.row].done

        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add todo item", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add item", style: .default) { (action) in
            let item = Item()
                item.title = textField.text!
            
            self.itemArray.append(item)
            self.defaults.set(self.itemArray, forKey: "Todo")
            self.tableView.reloadData()
          
            
            //print(textField.text!)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new item"
            textField = alertTextField
        }
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
}

