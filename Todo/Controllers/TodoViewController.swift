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
    let dataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("item.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
      
        
        //print(dataPath)
        
        
       navigationItem.title = "Todo"
        let item1 = Item()
            item1.title = "Buy Toto"
        
        let item2 = Item()
            item2.title = "Buy Soap"
        
        itemArray.append(item1)
        itemArray.append(item2)
        
//        if let myDefaults =  defaults.array(forKey: "TodoArrayList") {
//           itemArray = myDefaults as! [Item]
//        }
       
        loadItems()
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

        self.saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add todo item", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add item", style: .default) { (action) in
            let item = Item()
                item.title = textField.text!
            
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
    
    func loadItems(){
        do {
        
            if let data =  try? Data(contentsOf: dataPath!) {
               let decoder = PropertyListDecoder()
                itemArray = try decoder.decode([Item].self, from: data)
                
            }
            
        }catch{
            print("\(error)")
        }
        
    }
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataPath!)
        }catch {
            print("\(error)")
        }
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
}

