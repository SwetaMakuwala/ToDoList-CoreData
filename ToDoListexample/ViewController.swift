//
//  ViewController.swift
//  ToDoListexample
//
//  Created by sweta makuwala on 20/11/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var dateString = " "
    var nameString = " "
    let tableView : UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
   private var models = [Item]()
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllItems()
    
        
        // Do any additional setup after loading the view.
        title = "To Do List"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    @objc private func didTapAdd(){
        //date:
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateString = dateFormatter.string(from: Date())
        let alert = UIAlertController(title: "New Item", message: "Enter New Item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: {[weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            self?.createItem(name: text, date: self?.dateString ?? "blank")
        }))
        present(alert, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let displayName = models[indexPath.row].name {
            nameString = displayName
        }
        if let displaydate = models[indexPath.row].date {
            dateString = displaydate
        }
        cell.textLabel?.text =  "\(nameString) - \(dateString)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         tableView.deselectRow(at: indexPath, animated: true)
        let item = models[indexPath.row]
        print(item)
        let sheet = UIAlertController(title: "Action", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: {_ in
            
            let alert = UIAlertController(title: "Edit Item", message: "Edit your Item", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            
            alert.textFields?.first?.placeholder = item.name
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: {[weak self] _ in
                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {
                    return
                }
            
               // tableView.cellForRow(at: indexPath)?.textLabel?.text = newName
               self?.updateItem(item: item, newName : newName)
                
                
            }))
            self.present(alert, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {[weak self] _ in
            self?.deleteItm(item: item)
        }))
        present(sheet, animated: true)
    }
    
    
    // core data
    func getAllItems(){
        do {
        models = try context.fetch(Item.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            
        }
      
    }
    func createItem(name: String, date: String){
        let newItem = Item(context: context)
        newItem.name = name
        newItem.date = date
        do{
            try context.save()
            getAllItems()
        }catch{
            
        }
        
       
    }
    func deleteItm(item: Item){
        context.delete(item)
        do{
          try context.save()
            getAllItems()
        }catch {
            print("delete error: \(error)")
        }
    }
    func updateItem(item: Item, newName : String){
        item.name = newName
        do{
            try context.save()
            getAllItems()
        }catch{
        }
       }
}

