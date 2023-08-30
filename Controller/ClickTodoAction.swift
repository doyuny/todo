//
//  File.swift
//  Todo
//
//  Created by 김도윤 on 2023/08/08.
//

import UIKit
extension clicktodo {
    @IBAction func addclick(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "할일추가", message: "\n", preferredStyle: .alert)
        alert.addTextField { textField in
            self.configPickerView(for: textField)
        }
        
        let add = UIAlertAction(title: "add", style: .default) { _ in
            guard self.selectedSectionIndex >= 0 && self.selectedSectionIndex < self.data.count else {
                return
            }
            let textField = alert.textFields?.first
            if let newTodo = textField?.text, !newTodo.isEmpty {
                self.data[self.selectedSectionIndex].append(newTodo)
                self.switchStates[self.selectedSectionIndex].append(false)
                UserDefaults.standard.set(self.data, forKey: "ToDoData")
                
                self.tableView.reloadData()
            }
        }
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel) { _ in }
        alert.addAction(cancel)
        alert.addAction(add)
        
        present(alert, animated: true, completion: nil)
    }

    @IBAction func deleteclick(_ sender: Any) {
        let nonEmptySectionsCount = data.filter { !$0.isEmpty }.count
        if nonEmptySectionsCount == 1, data[0].count == 1 {
            if let item = data[0].first {
                showDeleteConfirmationAlert(for: item, at: IndexPath(row: 0, section: 0))
            }
        } else {
            let alert = UIAlertController(title: "삭제할 수 있는 항목", message: "삭제할 todo를 골라주세요", preferredStyle: .alert)
            
            for sectionIndex in 0..<data.count {
                let sectionData = data[sectionIndex]
                for (index, item) in sectionData.enumerated() {
                    let action = UIAlertAction(title: item, style: .default) { _ in
                        self.showDeleteConfirmationAlert(for: item, at: IndexPath(row: index, section: sectionIndex))
                    }
                    alert.addAction(action)
                }
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            
            present(alert, animated: true, completion: nil)
        }
    }

    func showDeleteConfirmationAlert(for item: String, at indexPath: IndexPath) {
        let confirmationAlert = UIAlertController(title: "삭제확인", message: "'\(item)'을(를) \n 정말로 삭제하시겠습니까?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "OK", style: .destructive) { _ in
            
            self.data[indexPath.section].remove(at: indexPath.row)
            
            UserDefaults.standard.set(self.data, forKey: "ToDoData")
            
            self.tableView.reloadData()
        }
        
        let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        confirmationAlert.addAction(yesAction)
        confirmationAlert.addAction(noAction)
        
        present(confirmationAlert, animated: true, completion: nil)
    }

    @objc func switchChanged(_ sender: UISwitch) {
        let section = sender.tag / 1000
        let row = sender.tag % 1000

        guard section < switchStates.count, row < switchStates[section].count else {
            return
        }

        switchStates[section][row] = sender.isOn

        UserDefaults.standard.set(switchStates, forKey: "SwitchStates")

        var onTasks: [[String]] = Array(repeating: [], count: data.count)

        for sec in 0..<data.count {
            guard sec < switchStates.count else {
                continue
            }

            for index in 0..<data[sec].count {
                guard index < switchStates[sec].count else {
                    continue
                }
                if switchStates[sec][index] {
                    onTasks[sec].append(data[sec][index])
                }
            }
        }

        UserDefaults.standard.set(onTasks, forKey: "CompletedTasksData")
        NotificationCenter.default.post(name: NSNotification.Name("CompletedTasksChanged"), object: nil)
    }

    @IBAction func navigateToCompletedTasks(_ sender: Any) {
        let completeVC = CompletelistViewController()
        var onTasks: [[String]] = Array(repeating: [], count: data.count)
        for section in 0..<data.count {
            for row in 0..<data[section].count {
                if switchStates[section][row] {
                    onTasks[section].append(data[section][row])
                }
            }
        }
        
        UserDefaults.standard.set(onTasks, forKey: "CompletedTasksData")
        
        if navigationController == nil {
            print("clicktodo is not embedded in a UINavigationController.")
        }
        navigationController?.pushViewController(completeVC, animated: true)
        
        NotificationCenter.default.post(name: NSNotification.Name("CompletedTasksChanged"), object: nil)
    }

    @objc func handleCompletedTasksChanged(_ notification: NSNotification) {
        if let savedCompletedTasks = UserDefaults.standard.array(forKey: "CompletedTasksData") as? [[String]] {
            for section in 0..<savedCompletedTasks.count {
                for row in 0..<savedCompletedTasks[section].count {
                    if let index = data[section].firstIndex(of: savedCompletedTasks[section][row]) {
                        switchStates[section][index] = true
                    }
                }
            }
        }
    }
}
