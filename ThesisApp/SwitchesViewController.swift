//
//  SwitchesViewController.swift
//  ThesisApp
//
//  Created by Matteo Salvatore on 22/09/22.
//

import UIKit

class SwitchesViewController: UIViewController {
    @IBOutlet var switch1: UISwitch!
    @IBOutlet var switch2: UISwitch!
    @IBOutlet var switch3: UISwitch!
    
    @IBOutlet var label1: UILabel!
    @IBOutlet var label2: UILabel!
    @IBOutlet var label3: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch1.isOn = false
        switch2.isOn = false
        switch3.isOn = false
        label1.text = "Switch1 is off"
        label2.text = "Switch2 is off"
        label3.text = "Switch3 is off"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func switch1Action(_ sender: UISwitch) {
        if sender.isOn{
            label1.textColor = .systemGreen
            label1.text = "Switch1 is on"
        }else{
            label1.textColor = .black
            label1.text = "Switch1 is off"
        }
    }
    
    @IBAction func switch2Action(_ sender: UISwitch) {
        if sender.isOn{
            label2.textColor = .systemGreen
            label2.text = "Switch2 is on"
        }else{
            label2.textColor = .black
            label2.text = "Switch2 is off"
        }
    }
    
    @IBAction func switch3Action(_ sender: UISwitch) {
        if sender.isOn{
            label3.textColor = .systemGreen
            label3.text = "Switch3 is on"
        }else{
            label3.textColor = .black
            label3.text = "Switch3 is off"
        }
    }
    
}
