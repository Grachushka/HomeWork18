//
//  ViewController.swift
//  HomeWork18
//
//  Created by Pavel Procenko on 10/09/2019.
//  Copyright © 2019 Pavel Procenko. All rights reserved.
//

import UIKit
import RealmSwift

class ShowPhonesVC: UIViewController {
    
    var phones = DataBaseRealmSwift.shared.getPhones()
    
    @IBOutlet weak var table: UITableView!
    private var notificationToken: NotificationToken!
    private weak var okAction: UIAlertAction?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.allowsSelection = false
        
        notificationToken = phones!.observe { [weak self] change in
            guard let self = self else { return }
            
            switch change {
            case .initial:
                self.table.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                self.table.beginUpdates()
                self.table.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .fade)
                self.table.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .fade)
                self.table.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .fade)
                self.table.endUpdates()
            case .error(let error):
                print(error)
            }
        }

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let phone = phones![indexPath.row]
            
           DataBaseRealmSwift.shared.deletePhone(phone: phone)

        }
    }
        
    
    @IBAction func addAction(_ sender: Any) {
        let alert = UIAlertController(title: "Add Note", message: "Enter name for new note", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            let textFieldName = alert.textFields![0]
            let textFieldPrice = alert.textFields![1]
            
            let phone = Phone()
            phone.name = textFieldName.text!
            phone.price.value = Double(textFieldPrice.text!)
            DataBaseRealmSwift.shared.addPhone(phone: phone)
            
        }
        okAction.isEnabled = false
        self.okAction = okAction
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(okAction)
        alert.addTextField { textField in
            textField.placeholder = "iphone"
            textField.textAlignment = .center
            textField.addTarget(self, action: #selector(self.textFieldWasEdited(sender:)), for: .allEditingEvents)
        }
        alert.addTextField { textField in
            textField.placeholder = "price"
            textField.textAlignment = .center
            textField.addTarget(self, action: #selector(self.textFieldWasEdited(sender:)), for: .allEditingEvents)
        }
        
        present(alert, animated: true)
    }
    @objc
    private func textFieldWasEdited(sender: UITextField) {
        okAction?.isEnabled = sender.text!.count >= 1
    }
    
}

extension ShowPhonesVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return phones!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let note = phones![indexPath.row]
        cell.textLabel?.text = note.name
        cell.detailTextLabel?.text = "\(note.price.value!)$"
        return cell
        
    }
    
    
}



