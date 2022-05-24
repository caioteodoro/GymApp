//
//  RegisterViewController.swift
//  GymApp
//
//  Created by Caio Teodoro on 23/05/22.
//

import UIKit
import MaterialComponents
import FirebaseAuth
import Firebase

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
                        title: "Registre-se",
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
        
        errorLabel.alpha = 0
        
    }
    
    func isPasswordValid(_ password: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    func validateFields() -> String? {
        
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Preencha todos os campos."
        }
        
        let cleanedPassword = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if isPasswordValid(cleanedPassword!) == false {
            return "Senha não cumpre com requisitos."
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
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        
        let error = validateFields()
        if error != nil {
            printError(error!)
        } else {
            
            let firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email!, password: password!) { (result, err) in
                
                if err != nil  {
                    self.printError("Erro ao criar usuário." + err!.localizedDescription)
                } else {
                    
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstname":firstName!,"lastname":lastName!, "uid":result!.user.uid]) { (error) in
                        
                        if error != nil {
                            self.printError("Erro ao salvar dados do usuário.")
                            
                        }
                    }
                }
            }
            
            self.transitionToHomeScreen()
            
        }
        
    }
    
}
