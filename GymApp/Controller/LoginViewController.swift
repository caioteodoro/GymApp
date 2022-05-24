//
//  LoginViewController.swift
//  GymApp
//
//  Created by Caio Teodoro on 23/05/22.
//

import UIKit
import MaterialComponents
import FirebaseAuth

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
    
    func validateFields() -> String? {
        
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Preencha todos os campos."
        }
        return nil
    }
    
    func printError (_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHomeScreen() {
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as? HomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        let error = validateFields()
        if error != nil {
            printError(error!)
        } else {
            
            let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().signIn(withEmail: email!, password: password!) { result, err in
                
                if err != nil  {
                    self.printError("Erro ao fazer login." + err!.localizedDescription)
                } else {
                    self.transitionToHomeScreen()
                }
                
            }
            
        }
        
    }
    
}
