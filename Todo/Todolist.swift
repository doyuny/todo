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

    @IBAction func deleteclick(_ sender: Any) {
        let alert = UIAlertController(title: "삭제할 수 있는 항목", message: "삭제할 todo를 골라주세요", preferredStyle: .alert)

                // Add a list of items from all sections to the alert as actions
                for sectionIndex in 0..<self.data.count {
                    let sectionData = self.data[sectionIndex]
                    for (index, item) in sectionData.enumerated() {
                        let action = UIAlertAction(title: item, style: .default) { _ in
                            self.showDeleteConfirmationAlert(for: item, at: IndexPath(row: index, section: sectionIndex))
                        }
                        alert.addAction(action)
                    }
                }

                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(cancel)

                self.present(alert, animated: true, completion: nil)
            }

            func showDeleteConfirmationAlert(for item: String, at indexPath: IndexPath) {
                let confirmationAlert = UIAlertController(title: "삭제확인", message: "'\(item)'을(를) \n 정말로 삭제하시겠습니까?", preferredStyle: .alert)

                let yesAction = UIAlertAction(title: "네", style: .destructive) { _ in
                    // Remove the selected item from the data array
                    self.data[indexPath.section].remove(at: indexPath.row)

                    // Save updated data to UserDefaults
                    UserDefaults.standard.set(self.data, forKey: "ToDoData")

                    // Reload the table view to reflect the changes
                    self.tableView.reloadData()
                }

                let noAction = UIAlertAction(title: "아니요", style: .cancel, handler: nil)

                confirmationAlert.addAction(yesAction)
                confirmationAlert.addAction(noAction)

                self.present(confirmationAlert, animated: true, completion: nil)
            }

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
