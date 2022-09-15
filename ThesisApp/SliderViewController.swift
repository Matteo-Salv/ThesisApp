//
//  SliderViewController.swift
//  ThesisApp
//
//  Created by Matteo Salvatore on 15/09/22.
//

import UIKit

class SliderViewController: UIViewController {
    @IBOutlet var sliderOutlet: UISlider!
    @IBOutlet var sliderValueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sliderValueLabel.text = String(sliderOutlet.value)
    }
    
    @IBAction func usedSlider(_ sender: UISlider) {
        if sender.value <= 0.25{
            self.view.backgroundColor = .yellow
        }else if sender.value > 0.25 && sender.value < 0.5{
            self.view.backgroundColor = .green
        }else if sender.value == 0.5{
            self.view.backgroundColor = .white
        }else if sender.value > 0.5 && sender.value <= 0.75{
            self.view.backgroundColor = .cyan
        }else if sender.value > 0.75{
            self.view.backgroundColor = .gray
        }
        //x * 100 / 100 serve ad arrotondare al secondo decimale
        sliderValueLabel.text = String(round(sender.value * 100)/100)
    }
    
}
