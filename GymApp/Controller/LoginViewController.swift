//
//  LoginViewController.swift
//  GymApp
//
//  Created by Caio Teodoro on 23/05/22.
//

import UIKit
import MaterialComponents

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: MDCOutlinedTextField!
    @IBOutlet weak var passwordTextField: MDCOutlinedTextField!
    @IBOutlet weak var loginButton: MDCButton!
    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.creamColor
        customizeButton(button: loginButton,
                        bgColor: UIColor.charcoalColor,
                        title: "Login",
                        txtColor: UIColor.white)
        
        customizeOutlinedTextField(textField: emailTextField,
                                   label: "E-mail",
                                   placeholder: "joao@silva.com",
                                   normalColor: UIColor.goldColor,
                                   editingColor: UIColor.tanColor)
        
        customizeOutlinedTextField(textField: passwordTextField,
                                   label: "Senha",
                                   placeholder: "********",
                                   normalColor: UIColor.goldColor,
                                   editingColor: UIColor.tanColor)
        
        errorLabel.alpha = 0
    }
    


}
