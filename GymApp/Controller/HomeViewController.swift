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
import FirebaseFirestoreSwift

class HomeViewController: UIViewController {
    
    @IBOutlet weak var newWorkoutButton: MDCButton!
    @IBOutlet weak var refreshButton: MDCButton!
    @IBOutlet weak var workoutsTableView: UITableView!
    
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid
    var userWorkouts = [Treino]()
    
    func setTitleToName() {
        
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
    
    func stringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy HH:mm" //yyyy
        return formatter.string(from: date)
    }
    
    @IBAction func refresh(_ sender: Any) {
        
        updateTableView()
    }
    
    
    @objc func updateTableView() {
        
        db.collection("customWorkouts").whereField("userID", isEqualTo: uid!).getDocuments { snapshot, error in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                for document in snapshot!.documents {
                    let documentName = document.get("nome") as! Int
                    print("Nome: " + String(documentName))
                    if documentName == self.userWorkouts.count {
                        let documentDate = document.get("data") as! Timestamp
                        let documentDescription = document.get("descricao") as! String
                        self.userWorkouts.append(Treino(nome: documentName,
                                                        descricao: documentDescription,
                                                        data: documentDate.dateValue()))
                    }
                }
            }
        }
        print("Array: " + String(userWorkouts.count))
        self.workoutsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeButton(button: newWorkoutButton,
                        bgColor: UIColor.charcoalColor,
                        title: "Novo treino",
                        txtColor: UIColor.white)
        customizeButton(button: refreshButton,
                        bgColor: UIColor.charcoalColor,
                        title: "Atualizar",
                        txtColor: UIColor.white)
        
        setTitleToName()
        
        workoutsTableView.delegate = self
        workoutsTableView.dataSource = self
        
        getWorkouts()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTableView), name: NSNotification.Name("UpdateTableViewIdentifier"), object: nil)

    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func getWorkouts() {
        
        db.collection("customWorkouts").whereField("userID", isEqualTo: uid!).getDocuments { snapshot, error in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                for document in snapshot!.documents {
                    let documentDate = document.get("data") as! Timestamp
                    let documentDescription = document.get("descricao") as! String
                    let documentName = document.get("nome") as! Int
                    self.userWorkouts.append(Treino(nome: documentName,
                                                    descricao: documentDescription,
                                                    data: documentDate.dateValue()))
            }
                self.workoutsTableView.reloadData()
            }
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userWorkouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell", for: indexPath) as? CustomCell else { fatalError() }
        
        cell.titleLabel.text = userWorkouts[indexPath.row].descricao
        cell.descriptionLabel.text = "Última atualização: " + stringFromDate(userWorkouts[indexPath.row].data)
        let iconView = UIImage(named: "exercise-icon")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        iconView?.withTintColor(UIColor.charcoalColor)
        cell.icon.image = iconView

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            userWorkouts.remove(at: indexPath.row)
            workoutsTableView.deleteRows(at: [indexPath], with: .fade)
            db.collection("customWorkouts").whereField("userID", isEqualTo: uid!).getDocuments { snapshot, err in
                if err != nil {
                    print(err!.localizedDescription)
                } else {
                    for document in snapshot!.documents {
                        let documentName = document.get("nome") as! Int
                        let documentID = document.documentID
                        if documentName == indexPath.row {
                            self.db.collection("customWorkouts").document(documentID).delete()
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let editWorkoutVC = (storyboard?.instantiateViewController(withIdentifier: "EditWorkoutVC"))! as UIViewController
        self.present(editWorkoutVC, animated: true, completion: nil)
    }
    
}



