//
//  ViewController.swift
//  Reminder
//
//  Created by Admin on 29.06.2020.
//  Copyright © 2020 BG. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    let searchController = UISearchController(searchResultsController: nil)
               var models = [MyReminder]()
      var searchItem = [MyReminder]()

    @IBOutlet var table: UITableView!
   
        override func viewDidLoad() {
            super.viewDidLoad()
            searchController.searchResultsUpdater = self
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = "Search"
            navigationItem.searchController = searchController
            definesPresentationContext = true
          
         
            table.delegate = self
            table.dataSource = self
           
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
                if success {
                    self.Scheduling()
                    
                } else  {
                    
                }
            }
            
        }
        
     
        func Scheduling() {
            let content = UNMutableNotificationContent()
            content.title = "Hello world"
            content.sound = .default
            content.body = "hi baby, hi baby"
            let targetDate = Date().addingTimeInterval(10)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .minute, .second], from: targetDate), repeats: false)
            let request = UNNotificationRequest(identifier: "LONG_ID", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                if error != nil {
                    print("some error occured")
                }
                
            }
            
            
            
        }
        
    @IBAction func addTapped(_ sender: Any) {
    
    
            guard let vc = storyboard?.instantiateViewController(identifier: "Add") as? AddViewController else {
            return
            }
            vc.title = "New Reminder"
            vc.navigationItem.largeTitleDisplayMode = .never
            vc.completion = {title, body, date in
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                    
                    let new = MyReminder(title: title, date: date, identifier: "id_\(title)")
                    self.models.append(new)
                     
                    self.table.reloadData()
                    let content = UNMutableNotificationContent()
                       content.title = title
                       content.sound = .default
                       content.body = body
                       let targetDate = date
                       
                       let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .minute, .second], from: targetDate), repeats: false)
                       let request = UNNotificationRequest(identifier: "LONG_ID", content: content, trigger: trigger)
                       UNUserNotificationCenter.current().add(request) { (error) in
                           if error != nil {
                               print("some error occured")
                           }
                           
                       }
                    
                }
                
            }
            navigationController?.pushViewController(vc, animated: true)
        }
}
        
    

    extension ViewController : UITableViewDelegate {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
        }
        func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
           
        }
        
       func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }

       func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
                let alert = UIAlertController(title: "", message: "Edit list item", preferredStyle: .alert)
                alert.addTextField(configurationHandler: { (textField) in
                    textField.text = self.models[indexPath.row].title
                  
                })
                alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (updateAction) in
                    self.models[indexPath.row].title = alert.textFields!.first!.text!
                    self.table.reloadRows(at: [indexPath], with: .fade)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: false)
            })

            let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
                self.models.remove(at: indexPath.row)
                self.table.reloadData()
            })
        let archiveAction = UITableViewRowAction(style: .default, title: "Archive", handler: { (action, indexPath) in
            let arc = self.models.remove(at: indexPath.row)
                   self.table.reloadData()
               })

            return [deleteAction, editAction, archiveAction]
        }
        
        func filterContent(for searchText: String, scope: String = "All") {
            searchItem = models.filter({ word in
                return word.title.lowercased().contains(searchText.lowercased())
                
            })
            table.reloadData()
        }
        
        
        
    }
    extension ViewController : UITableViewDataSource {
        func numberOfSections(in tableView: UITableView) -> Int {
           return 1
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            if self.searchController.isActive {
                return searchItem.count
            }else {
            return models.count
            }
          
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text  = models[indexPath.row].title
            let date = models[indexPath.row].date
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM, dd, YYYY"
            let todate = Date()
           
            
           
            cell.detailTextLabel?.text = formatter.string(from: date)
            
            let order = NSCalendar.current.compare(todate, to: date, toGranularity: .day)
            switch order {
            case .orderedSame:
                cell.contentView.backgroundColor = UIColor.green
            case .orderedDescending :
                 cell.contentView.backgroundColor = UIColor.red
                
            default :
                cell.contentView.backgroundColor = UIColor.lightGray
            }
          return cell
        }
        
        
    }

    struct MyReminder {
        var title : String
        let date : Date
        let identifier: String
        
        
        
    }
    extension ViewController : UISearchResultsUpdating {
        func updateSearchResults(for searchController: UISearchController) {
            filterContent(for: searchController.searchBar.text!)
        }
}

