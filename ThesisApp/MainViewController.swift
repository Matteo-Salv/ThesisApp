//
//  ViewController.swift
//  ThesisApp
//
//  Created by Matteo Salvatore on 14/09/22.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet var authorTextView: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        let attributedString = NSMutableAttributedString(string: "Author: Matteo Salvatore (@Matteo-Salv)")
        let range = NSRange(location: 27, length: 11)
        let url = URL(string: "https://github.com/Matteo-Salv")!
        attributedString.setAttributes([.link: url], range: range)
        authorTextView.textStorage.setAttributedString(attributedString)
        
        authorTextView.linkTextAttributes = [
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

