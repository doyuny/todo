//
//  File.swift
//  Todo
//
//  Created by 김도윤 on 2023/08/01.
//

import UIKit

class clicktodo: UIViewController, UITableViewDataSource {
    @IBAction func addclick(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "할일추가", message: "\n", preferredStyle: .alert)
        alert.addTextField { textField in
            self.configPickerView(for: textField) // Add pickerView as inputView to the textField
        }

        let add = UIAlertAction(title: "add", style: .default) { _ in
            guard self.selectedSectionIndex >= 0 && self.selectedSectionIndex < self.data.count else {
                return
            }
            let textField = alert.textFields?.first
            if let newTodo = textField?.text, !newTodo.isEmpty {
                self.data[self.selectedSectionIndex].append(newTodo)

                // Save data to UserDefaults
                UserDefaults.standard.set(self.data, forKey: "ToDoData")

                self.tableView.reloadData()
            }
        }

        let cancel = UIAlertAction(title: "cancel", style: .cancel) { _ in }
        alert.addAction(cancel)
        alert.addAction(add)

        self.present(alert, animated: true, completion: nil)
    }

    var tableView = UITableView(frame: .zero, style: .insetGrouped)
    let header = ["Section1", "Section2", "Section3"]
    var data = [["Test 1-1", "Test 1-2"], ["Test 2-1", "Test 2-2"], ["Test 3-1", "Test 3-2"]] // Declare data as a variable

    var readTF = UITextField()
    var selectedSectionIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
        self.tableView.dataSource = self

        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
        configPickerView(for: self.readTF) // Pass the readTF UITextField to the configPickerView method

        // Load saved data from UserDefaults
        if let savedData = UserDefaults.standard.array(forKey: "ToDoData") as? [[String]] {
            self.data = savedData
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: .none)
        cell.textLabel?.text = self.data[indexPath.section][indexPath.row]
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.data.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.header[section]
    }
}

extension clicktodo: UIPickerViewDelegate, UIPickerViewDataSource {
    func configPickerView(for textField: UITextField) {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        textField.inputView = picker
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.header.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.header[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedSectionIndex = row
    }
    
}
