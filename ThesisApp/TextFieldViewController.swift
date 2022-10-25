//
//  TextFieldViewController.swift
//  ThesisApp
//
//  Created by Matteo Salvatore on 19/09/22.
//

import UIKit

class TextFieldViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet var firstTextFieldOutlet: UITextField!
    @IBOutlet var secondLabel: UILabel!
    @IBOutlet var secondTextFieldOutlet: UITextField!
    @IBOutlet var firstLabel: UILabel!
    @IBOutlet var confirmButton: UIButton!
    
    //dopo aver impostato il delegato su self
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        secondTextFieldOutlet.placeholder = "write something..."
        firstTextFieldOutlet.placeholder = "Write something and then click on confirm..."
        firstLabel.text = ""
        secondLabel.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstTextFieldOutlet.returnKeyType = .done
        firstTextFieldOutlet.delegate = self
        secondTextFieldOutlet.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @IBAction func secondTextFieldAction(_ sender: UITextField) {
        secondLabel.text = sender.text!
    }
    
    @IBAction func confirmButton(_ sender: Any) {
        let valueInserted = firstTextFieldOutlet.text!
        if valueInserted == ""{
            firstLabel.text = "Insert a valid text!"
        }else{
            firstLabel.text = valueInserted
        }
    }
}
