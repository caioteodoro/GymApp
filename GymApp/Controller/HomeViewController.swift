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
    var userDocumentId = ""
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
    
    func getUserdocumentId () {
        var temporaryArray = [String]()
        db.collection("users").whereField("uid", isEqualTo: uid!).getDocuments { snapshot, err in
            if err != nil {
                print(err!.localizedDescription)
            } else {
                for document in snapshot!.documents {
                    temporaryArray.append(document.documentID)
                    self.userDocumentId = temporaryArray[0]
                    self.getWorkouts()
                }
            }
        }
    }
    
    @objc func updateTableView() {
        
        db.collection("users").document(userDocumentId).collection("customWorkouts").getDocuments { snapshot, err in
            if err != nil {
                Swift.print(err!.localizedDescription)
            } else {
                if snapshot?.count != self.userWorkouts.count {
                    for document in snapshot!.documents {
                        let documentName = document.get("nome") as! Int
                        if !self.userWorkouts.contains(where: { treino in
                            treino.nome == documentName
                        }) {
                            let documentDate = document.get("data") as! Timestamp
                            let documentDescription = document.get("descricao") as! String
                            self.userWorkouts.append(Treino(nome: documentName,
                                                            descricao: documentDescription,
                                                            data: documentDate.dateValue()))
                        }
                    }
                }
                self.workoutsTableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewWorkoutVCSegue" {
            if let newWorkoutVC = segue.destination as? NewWorkoutViewController {
                newWorkoutVC.userWorkouts = self.userWorkouts
            }
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        updateTableView()
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
        
        workoutsTableView.delegate = self
        workoutsTableView.dataSource = self
        
        setTitleToName()
        getUserdocumentId()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTableView), name: NSNotification.Name("UpdateTableViewIdentifier"), object: nil)

    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func getWorkouts() {

        db.collection("users").document(userDocumentId).collection("customWorkouts").getDocuments { snapshot, err in
            if err != nil {
                print(err!.localizedDescription)
            } else {
                var rawWorkouts = [Treino]()
                for document in snapshot!.documents {
                    let documentDate = document.get("data") as! Timestamp
                    let documentDescription = document.get("descricao") as! String
                    let documentName = document.get("nome") as! Int
                    rawWorkouts.append(Treino(nome: documentName,
                                                    descricao: documentDescription,
                                                    data: documentDate.dateValue()))
            }
                self.userWorkouts = rawWorkouts.sorted { treinoA, treinoB in
                    treinoA.nome < treinoB.nome
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
        cell.descriptionLabel.text = "Último treino: " + stringFromDate(userWorkouts[indexPath.row].data)
        let iconView = UIImage(named: "exercise-icon")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        iconView?.withTintColor(UIColor.charcoalColor)
        cell.icon.image = iconView

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            userWorkouts.remove(at: indexPath.row)
            workoutsTableView.deleteRows(at: [indexPath], with: .fade)
            let localWorkoutName = userWorkouts[indexPath.row - 1].nome
            db.collection("users").document(userDocumentId).collection("customWorkouts").whereField("nome", isEqualTo: localWorkoutName).getDocuments { snapshot, err in
                if err != nil {
                    print(err!.localizedDescription)
                } else if snapshot!.count > 1 {
                    print("Mais de um documento encontrado.")
                } else {
                    let document = snapshot!.documents.first
                    let documentName = document!.get("nome") as! Int
                    let documentID = document!.documentID
                    if documentName == localWorkoutName {
                        self.db.collection("users").document(self.userDocumentId).collection("customWorkouts").document(documentID).delete()
                    }
                }
            }
        }
    }
    
    func openWorkoutVC(_ indexPathRow: Int) {
        let workoutVC = (storyboard?.instantiateViewController(withIdentifier: "WorkoutVC"))! as! WorkoutViewController
        workoutVC.userDocumentId = self.userDocumentId
        workoutVC.currentWorkout = self.userWorkouts[indexPathRow]
        self.present(workoutVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        openWorkoutVC(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openWorkoutVC(indexPath.row)
    }
    
}



