//
//  CategoryViewController.swift
//  Todo
//
//  Created by 吴启德 on 6/10/18.
//  Copyright © 2018 吴启德. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {
    
    var categoryArray: Results<Category>?
    
   
    let realm = try! Realm()
    

    override func viewDidLoad() {
        super.viewDidLoad()

       loadCategory()
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell")!
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No category added"
        
        return cell
        
    }

    func loadCategory(){
        categoryArray =  realm.objects(Category.self)
        
        tableView.reloadData()

    }
    
    func save(category: Category){
        do {
            try realm.write {
                realm.add(category)
            }
        }catch {
            print("\(error)")
        }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! TodoViewController
        if let selectedIndex = tableView.indexPathForSelectedRow {
          destVC.selectedCategory = categoryArray?[selectedIndex.row]
        }
    }
    
    @IBAction func buttonPressedAction(_ sender: UIBarButtonItem) {
        
       let alertController =  UIAlertController(title: "Add", message: "Please add a new category", preferredStyle: .alert)
        
        var newCategoryText: UITextField = UITextField()
        
        let alertAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            //print("\(newCategoryText.text!)")
            let cat = Category()
                cat.name = newCategoryText.text!
            
            //self.categoryArray.append(cat)
            self.save(category: cat)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addTextField { (textField) in
            newCategoryText = textField
        }
        
        alertController.addAction(alertAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
        
        
        
    }
    
}
