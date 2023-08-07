//
//  File.swift
//  Todo
//
//  Created by 김도윤 on 2023/08/01.
//
import UIKit

class CompletelistViewController: UITableViewController {
    
    var completedTasks: [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "completedTaskCell")
        NotificationCenter.default.addObserver(self, selector: #selector(handleCompletedTasksChanged(_:)), name: NSNotification.Name("CompletedTasksChanged"), object: nil)
    }
    
    @objc func handleCompletedTasksChanged(_ notification: NSNotification) {
        // fetch the completed tasks data and reload the table view
        if let completedData = UserDefaults.standard.array(forKey: "CompletedTasksData") as? [[String]] {
            self.completedTasks = completedData
        }
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return completedTasks.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedTasks[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "completedTaskCell", for: indexPath)
        cell.textLabel?.text = completedTasks[indexPath.section][indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section + 1)"
    }
}
