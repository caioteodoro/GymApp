//
//  NewWorkoutViewController.swift
//  GymApp
//
//  Created by Caio Teodoro on 29/05/22.
//

import UIKit
import FirebaseFirestore
import MaterialComponents
import SwiftUI
import FirebaseFirestoreSwift

class NewWorkoutViewController: UIViewController {
    
    @IBOutlet weak var doneButton: MDCButton!
    @IBOutlet weak var workoutsTableView: UITableView!
    
//    private var service: ExercisesService?
//    private var exercises = [Exercicio]() {
//        didSet {
//            DispatchQueue.main.async {
//                self.workoutsTableView.reloadData()
//            }
//        }
//    }
//    var allExercises = [Exercicio]() {
//        didSet {
//            DispatchQueue.main.async {
//                self.exercises = self.allExercises
//            }
//        }
//    }
//
//    func loadData() {
//        service = ExercisesService()
//        service?.get(collectionID: "exercises", handler: { exercises in
//            self.allExercises = exercises
//        })
//    }
    
    var exercises = [Exercicio]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getExercises()
        //loadData()
        
        workoutsTableView.dataSource = self
        workoutsTableView.delegate = self
        
        customizeButton(button: doneButton,
                        bgColor: UIColor.creamColor,
                        title: "Concluído",
                        txtColor: UIColor.charcoalColor)
        
        
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
    }
    

}

extension NewWorkoutViewController: UITableViewDelegate, UITableViewDataSource {

    
    func getExercises() {
        let db = Firestore.firestore()
        
        db.collection("exercises").getDocuments { snapshot, error in
            if error != nil {
                print("Documentos não encontrados")
            } else {
                for document in snapshot!.documents {
                    let documentName = document.get("nome") as! Int
                    let documentImage = document.get("imagem") as! String
                    let documentDescription = document.get("obsevacoes") as! String
                    self.exercises.append(Exercicio(nome: documentName,
                                                    imagem: documentImage,
                                                    observacoes: documentDescription))
                }
                self.workoutsTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell", for: indexPath) as? CustomCell else { fatalError() }
        
        cell.titleLabel.text = "Treino 1"
        cell.descriptionLabel.text = "Membros superiores"
        let iconView = UIImage(named: "exercise-icon")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        iconView?.withTintColor(UIColor.creamColor)
        cell.icon.image = iconView

        return cell
    }
    
    
}
