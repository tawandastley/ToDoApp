//
//  CategoryViewController.swift
//  ToDo
//
//  Created by tawanda chandiwana on 2022/01/07.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        self.loadItems()
        super.viewDidLoad()
    }

    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let myAlert = UIAlertController(title: "ADD CATEGORY", message: "", preferredStyle: UIAlertController.Style.alert)
        let myAction = UIAlertAction(title: "ADD", style: UIAlertAction.Style.default) { (alert) in
            let newCategory = Category(context: self.context) //persist new category
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            self.saveItem()
           
        }
        myAlert.addTextField { (myTextField) in
            myTextField.placeholder = "add new category"
            textField = myTextField
            
        }
        myAlert.addAction(myAction)
        present(myAlert, animated: true, completion: nil)
        
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        cell.textLabel?.font = .italicSystemFont(ofSize: 18.0)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
  
    
    // MARK: - Table view Delegate methods
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourcerView, completionHandler) in
            self.context.delete(self.categories[indexPath.row])
            self.categories.remove(at: indexPath.row)
            self.saveItem()
            
        }
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        self.tableView.reloadData()
        return swipeConfig
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! ToDoTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationViewController.selectedCategory = categories[indexPath.row]
        }
    }
    
//MARK: -COREDATA METHODS
    
    func saveItem() {
        do {
            try context.save()
        }
        catch{
            print(error)
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do {
            categories = try context.fetch(request)
        }catch {
            print(error)
        }
        self.tableView.reloadData()
    }
    
}
