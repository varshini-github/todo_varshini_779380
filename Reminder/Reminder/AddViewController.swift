//
//  AddViewController.swift
//  Reminder
//
//  Created by Admin on 29.06.2020.
//  Copyright © 2020 BG. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var date: UIDatePicker!
    @IBOutlet var bodyTF: UITextField!
    @IBOutlet var titleTF: UITextField!
     public var completion : ((String, String, Date) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTF.delegate = self
               bodyTF.delegate = self

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
    

    @IBAction func saveBtn(_ sender: Any) {
        if let title = titleTF!.text, !titleTF.text!.isEmpty {
                    if let body = titleTF!.text, !bodyTF.text!.isEmpty {
                       let targetDate = date.date
                      
                     
                     
                       
                       completion?(title ,body, targetDate)
                       
                       
                   }
                   
               }
           }
    }
    

