//
//  File.swift
//  Todo
//
//  Created by 김도윤 on 2023/08/01.
//
import UIKit

class CompletelistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedTasks[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return completedTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "completedTaskCell", for: indexPath)
        cell.textLabel?.text = completedTasks[indexPath.section][indexPath.row]
        return cell
    }
    
    var completedTasks: [[String]] = []
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "completedTaskCell")
        
        view.addSubview(tableView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCompletedTasksChanged(_:)), name: NSNotification.Name("CompletedTasksChanged"), object: nil)
    }
    
    @objc func handleCompletedTasksChanged(_ notification: NSNotification) {
        if let completedData = UserDefaults.standard.array(forKey: "CompletedTasksData") as? [[String]] {
            completedTasks = completedData
        }
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let completedData = UserDefaults.standard.array(forKey: "CompletedTasksData") as? [[String]] {
            completedTasks = completedData
        }
        tableView.reloadData()
    }
}
    
func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Section \(section + 1)"
}
