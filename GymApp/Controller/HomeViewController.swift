//
//  HomeViewController.swift
//  GymApp
//
//  Created by Caio Teodoro on 23/05/22.
//

import UIKit
import MaterialComponents
import FirebaseAuth
import Firebase
import SwiftUI

class HomeViewController: UIViewController {
    
    @IBOutlet weak var newWorkoutButton: MDCButton!
    @IBOutlet weak var workoutsTableView: UITableView!
    
    func setTitleToName() {
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        
        db.collection("users").whereField("uid", isEqualTo: uid!).getDocuments { (snapshot, err) in
            if err != nil {
                self.title = "Olá!"
            } else {
                _ = snapshot?.documents.map { u in
                    let firstName = u["firstname"] as? String
                    self.title = "Olá, " + firstName! + "!"
                }
            }
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeButton(button: newWorkoutButton,
                        bgColor: UIColor.charcoalColor,
                        title: "Novo treino",
                        txtColor: UIColor.white)
        
        setTitleToName()
        
        workoutsTableView.delegate = self
        workoutsTableView.dataSource = self

    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell", for: indexPath) as? CustomCell else { fatalError() }
        
        cell.titleLabel.text = "Treino 1"
        cell.descriptionLabel.text = "Membros superiores"
        let iconView = UIImage(named: "exercise-icon")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        iconView?.withTintColor(UIColor.charcoalColor)
        cell.icon.image = iconView

        return cell
    }
    
    
}



