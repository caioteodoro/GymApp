//
//  ViewController.swift
//  GymApp
//
//  Created by Caio Teodoro on 21/05/22.
//

import UIKit
import MaterialComponents

class ViewController: UIViewController {

    @IBOutlet weak var registerButton: MDCButton!
    @IBOutlet weak var loginButton: MDCButton!
    
    func customizeButton(button: MDCButton,
                         color: UIColor,
                         title: String) {
        let button = button
        button.setTitle(title, for: .normal)
        button.setBackgroundColor(color)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.white, for: .selected)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeButton(button: loginButton,
                        color: UIColor.charcoalColor,
                        title: "Login")
        customizeButton(button: registerButton,
                        color: UIColor.charcoalColor,
                        title: "Registre-se")
        
        
        
    }
}

