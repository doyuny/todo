//
//  File.swift
//  Todo
//
//  Created by 김도윤 on 2023/08/01.
//

import UIKit

class clicktodo: UIViewController, UITableViewDataSource {
    var tableView = UITableView(frame: .zero, style: .insetGrouped)
    let header = ["Section1", "Section2", "Section3"]
    var data = [["Test 1-1", "Test 1-2"], ["Test 2-1", "Test 2-2"], ["Test 3-1", "Test 3-2"]] // Declare data as a variable
    
    var readTF = UITextField()
    var selectedSectionIndex = 0
    var tasks: [String] = []
    var completedTasks: [[String]] = []
    var switchStates: [[Bool]] = [] {
        didSet {
            UserDefaults.standard.set(switchStates, forKey: "SwitchStates")
        }
    }

    var onCompleteTasksClosure: (([[String]]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        configPickerView(for: readTF)
        
        if let savedData = UserDefaults.standard.array(forKey: "ToDoData") as? [[String]] {
            data = savedData
        }
        if let savedSwitchStates = UserDefaults.standard.array(forKey: "SwitchStates") as? [[Bool]] {
            switchStates = savedSwitchStates
        } else {
            let counts = data.map { $0.count }
            switchStates = counts.map { Array(repeating: false, count: $0) }
        }
        if let savedCompletedTasks = UserDefaults.standard.array(forKey: "CompletedTasksData") as? [[String]] {
            completedTasks = savedCompletedTasks
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCompletedTasksChanged(_:)), name: NSNotification.Name("CompletedTasksChanged"), object: nil)
        
        tableView.register(TodoCell.self, forCellReuseIdentifier: "cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section < data.count else {
            return UITableViewCell() // Or your fallback cell
        }

        guard indexPath.row < data[indexPath.section].count else {
            return UITableViewCell() // Or your fallback cell
        }

        guard indexPath.section < switchStates.count else {
            return UITableViewCell() // Or your fallback cell
        }

        guard indexPath.row < switchStates[indexPath.section].count else {
            return UITableViewCell() // Or your fallback cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TodoCell
        
        cell.textLabel?.text = data[indexPath.section][indexPath.row]
        cell.toggleSwitch.isOn = switchStates[indexPath.section][indexPath.row]
        cell.toggleSwitch.tag = indexPath.section * 1000 + indexPath.row
        cell.toggleSwitch.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return header[section]
    }
    
    func configPickerView(for textField: UITextField) {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        textField.inputView = pickerView
    }
}

extension clicktodo: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return header.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return header[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSectionIndex = row
    }
}
