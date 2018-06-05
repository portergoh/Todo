//
//  ViewController.swift
//  Todo
//
//  Created by 吴启德 on 6/5/18.
//  Copyright © 2018 吴启德. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {
    
    var itemArray = ["Go swimming pool", "Buy oranges", "Buy apples"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       navigationItem.title = "Todo"
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
            tableCell.textLabel?.text = itemArray[indexPath.row]
        
        
        return tableCell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
        }else{
            cell?.accessoryType = .checkmark
        }
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add todo item", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add item", style: .default) { (action) in
            self.itemArray.append(textField.text!)
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

