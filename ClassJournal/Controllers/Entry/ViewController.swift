//
//  ViewController.swift
//  ClassJournal
//
//  Created by Denis on 16/9/20.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit

open class ViewController: UIViewController {
    
    //MARK: - Variables
    var myTableView = UITableView()
    let cellIdentifier = "MyCell"
    var pupilsArray = ["Tim Rot", "James Bond", "Alehandro Lopes", "Den Black", "Jack Newman", "Anna Leonardo", "Mike Pompeo", "Kate Midleton", "Nick Brick", "Kim Kardashian"]
    
    //MARK: - viewDidLoad
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationButtons(left: .add, right: .edit)
        createTable(&myTableView, with: cellIdentifier)
        
    }
}

//MARK: - Method
extension ViewController {
    fileprivate func setNavigationButtons(left: UIBarButtonItem.SystemItem, right: UIBarButtonItem.SystemItem) {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: left, target: self, action: #selector(addPosition))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: right, target: self, action: #selector(editTable))
    }
    
    private func createTable(_ tableView: inout UITableView, with identifier: String) {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        tableView.isEditing = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(tableView)
    }
    
    private func alertPresent() {
        
        let alert = UIAlertController(title: "Add New Pupil", message: "Input name and surname", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
            textField.clearButtonMode = .whileEditing
            textField.autocapitalizationType = .words
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Surname"
            textField.clearButtonMode = .whileEditing
            textField.autocapitalizationType = .words

        }
        
        let action = UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
           
            let nameText = alert?.textFields?[0].text
            let surnameText = alert?.textFields![1].text
            let fullName = nameText! + " " + surnameText!
            self.pupilsArray.append(fullName)
            
            self.myTableView.beginUpdates()
            
            let indexPath = IndexPath(row: self.pupilsArray.count - 1, section: 0)
            self.myTableView.insertRows(at: [indexPath], with: .automatic)
        
            self.myTableView.endUpdates()
        })
        
        alert.addAction(action)
        present(alert, animated: true)
    }
}

//MARK: - Action
extension ViewController {
    @objc private func addPosition() {
        alertPresent()
    }
    
    @objc private func editTable() {
        myTableView.setEditing(!myTableView.isEditing, animated: true)
    }
}

//MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    //delete
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            pupilsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    
    //move
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let tempItem = pupilsArray[sourceIndexPath.row]
        pupilsArray.remove(at: sourceIndexPath.row)
        pupilsArray.insert(tempItem, at: destinationIndexPath.row)
    }
    
    //copy for strong tap
    public func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        
        if action == #selector(copy(_:)) {
            return true
        }
        return false
    }
    
    public func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        
        if action == #selector(copy(_:)) {
            let cell = tableView.cellForRow(at: indexPath)
            let pasteBoard = UIPasteboard.general
            pasteBoard.string = cell?.textLabel?.text
        }
    }
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return pupilsArray.count
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let name = pupilsArray[indexPath.row]
        
        cell.textLabel?.text = name
        return cell
    }
    
    
}

