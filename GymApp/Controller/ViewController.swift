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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeButton(button: loginButton,
                        bgColor: UIColor.charcoalColor,
                        title: "Login",
                        txtColor: UIColor.white)
        customizeButton(button: registerButton,
                        bgColor: UIColor.charcoalColor,
                        title: "Registre-se",
                        txtColor: UIColor.white)
        
    }
}

