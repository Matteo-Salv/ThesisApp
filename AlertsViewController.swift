//
//  AlertsViewController.swift
//  ThesisApp
//
//  Created by Matteo Salvatore on 15/09/22.
//

import UIKit

class AlertsViewController: UIViewController {
    @IBOutlet var genericAlertLabel: UILabel!
    @IBOutlet var alertWithTextFieldLabel: UILabel!
    
    var genericAlertMessage = UIAlertController(title: "Generic Alert", message: "what is the answer to the great question to Life, The Universe and Everything?", preferredStyle: .alert)
    
    var alertWithTextFieldMessage = UIAlertController(title: "Alert With Text Field", message: "Enter a text", preferredStyle: .alert)
    
    func createGenericAlertMessage(){
        let fourtyTwo = UIAlertAction(title: "42", style: .default, handler: { (action) -> Void in
            self.genericAlertLabel.text = "42 Button tapped"
        })
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.genericAlertLabel.text = "OK Button tapped"
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (action) -> Void in
            self.genericAlertLabel.text = "Cancel Button tapped"
        })
        
        genericAlertMessage.addAction(fourtyTwo)
        genericAlertMessage.addAction(ok)
        genericAlertMessage.addAction(cancel)
    }
    
    func createAlertWithTextFieldMessage(){
        alertWithTextFieldMessage.addTextField { textField in
            textField.placeholder = "insert message here"
        }
        let confirm = UIAlertAction(title: "Confirm", style: .default, handler: { (action) -> Void in
            if self.alertWithTextFieldMessage.textFields?.first?.text != ""{
                self.alertWithTextFieldLabel.text = "Confirm Button tapped, message \n'\(String(describing: self.alertWithTextFieldMessage.textFields!.first!.text!))'"
            }else{
                self.alertWithTextFieldLabel.text = "Confirm Button tapped, but no message inserted"
            }
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (action) -> Void in
            self.alertWithTextFieldLabel.text = "Cancel Button tapped"
        })
        
        alertWithTextFieldMessage.addAction(confirm)
        alertWithTextFieldMessage.addAction(cancel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        genericAlertLabel.text = "No interactions with first Alert yet"
        alertWithTextFieldLabel.text = "No interactions second Alert yet"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createGenericAlertMessage()
        createAlertWithTextFieldMessage()
    }

    @IBAction func genericAlertButtonPressed(_ sender: Any) {
        self.present(genericAlertMessage, animated: true, completion: nil)
    }
    
    @IBAction func alertWithTextFieldButtonPressed(_ sender: Any) {
        self.present(alertWithTextFieldMessage, animated: true, completion: nil)
    }
    
    
}
