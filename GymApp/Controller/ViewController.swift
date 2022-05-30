//
//  ViewController.swift
//  GymApp
//
//  Created by Caio Teodoro on 21/05/22.
//

import UIKit
import MaterialComponents
import FirebaseStorage
import SDWebImage

class ViewController: UIViewController {

    @IBOutlet weak var registerButton: MDCButton!
    @IBOutlet weak var loginButton: MDCButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    func loadBackground () {
        // Reference to an image file in Firebase Storage
        Storage.storage().reference().child("gs://gymapp-teodoro.appspot.com/images/loginBackground.jpeg").downloadURL { url, error in
            
            let placeholderImage = UIImage(named: "loginBackground.jpeg")
            self.backgroundImageView.sd_setImage(with: url, placeholderImage: placeholderImage)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadBackground()
        
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

