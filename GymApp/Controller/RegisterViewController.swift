//
//  RegisterViewController.swift
//  GymApp
//
//  Created by Caio Teodoro on 23/05/22.
//

import UIKit
import MaterialComponents

class RegisterViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: MDCOutlinedTextField!
    @IBOutlet weak var lastNameTextField: MDCOutlinedTextField!
    @IBOutlet weak var emailTextField: MDCOutlinedTextField!
    @IBOutlet weak var passwordTextField: MDCOutlinedTextField!
    @IBOutlet weak var registerButton: MDCButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.creamColor
        customizeButton(button: registerButton,
                        bgColor: UIColor.charcoalColor,
                        title: "Register",
                        txtColor: UIColor.white)
        
        customizeOutlinedTextField(textField: firstNameTextField,
                                   label: "Nome",
                                   placeholder: "João",
                                   normalColor: UIColor.goldColor,
                                   editingColor: UIColor.tanColor)
        
        customizeOutlinedTextField(textField: lastNameTextField,
                                   label: "Sobrenome",
                                   placeholder: "Silva",
                                   normalColor: UIColor.goldColor,
                                   editingColor: UIColor.tanColor)
        
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
        
    }

}
