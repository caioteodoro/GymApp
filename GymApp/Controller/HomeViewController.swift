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
    @IBOutlet weak var workoutsCollectionView: UICollectionView!
    
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
        
        workoutsCollectionView.delegate = self
        workoutsCollectionView.dataSource = self

    }

}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkoutCell", for: indexPath) as? MDCSelfSizingStereoCell else { fatalError() }
        
        cell.titleLabel.text = "Treino 1"
        cell.detailLabel.text = "Membros superiores"
        let iconView = UIImage(named: "exercise-icon")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        iconView?.withTintColor(UIColor.charcoalColor)
        cell.leadingImageView.image = iconView

        
        return cell
    }
    
}



extension HomeViewController: UICollectionViewDelegateFlowLayout {
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width), height: 88)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

}
