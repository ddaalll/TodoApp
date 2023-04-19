//
//  ViewController.swift
//  TodoApp
//
//  Created by DalHyun Nam on 2023/04/05.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    let toDoManager = CoreDataManager.shared
    
    var toDoData: MemoData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNaviBar()
        setupTabView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func setupNaviBar() {
        self.title = "메모"
        
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
        plusButton.tintColor = .black
        navigationItem.rightBarButtonItem = plusButton
    }
    
    func setupTabView() {
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    
    @objc func plusButtonTapped() {
        performSegue(withIdentifier: "ToDoCell", sender: nil)
    }
    
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoManager.getToDoListFromCoreData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoCell
        
        let toDoData = toDoManager.getToDoListFromCoreData()
        cell.toDoData = toDoData[indexPath.row]
        cell.updateButtonPressed = { [weak self] (senderCell) in self?.performSegue(withIdentifier: "ToDoCell", sender: indexPath)
            
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if (editingStyle == .delete) {
    //            toDoManager.deleteToDo(data: MemoData, completion: {})
    //        }
    //    }
    //
}
    extension ViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "ToDoCell", sender: indexPath)
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "ToDoCell" {
                let detailVC = segue.destination as! DetailViewController
                
                guard let indexPath = sender as? IndexPath else { return }
                detailVC.toDoData = toDoManager.getToDoListFromCoreData()[indexPath.row]
            }
        }
        
        
        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
        
        
    }

