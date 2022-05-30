//
//  EditWorkoutViewController.swift
//  GymApp
//
//  Created by Caio Teodoro on 30/05/22.
//

import UIKit
import MaterialComponents
import Firebase
import FirebaseAuth

class WorkoutViewController: UIViewController {

    var workoutName = 0
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid
    var exercisesNames = [Int]()
    var exercises = [Exercicio]()
    var userDocumentId = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addExerciseButton: MDCButton!
    @IBOutlet weak var doneButton: MDCButton!
    @IBOutlet weak var exercisesTableView: UITableView!
    @IBOutlet weak var lastWorkoutLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exercisesTableView.delegate = self
        exercisesTableView.dataSource = self
        
        customizeButton(button: addExerciseButton,
                        bgColor: UIColor.tanColor,
                        title: "Adicionar exercício",
                        txtColor: UIColor.charcoalColor)
        
        customizeButton(button: doneButton,
                        bgColor: UIColor.tanColor,
                        title: "Treino concluído",
                        txtColor: UIColor.charcoalColor)
        
        getExercises()
     
    }

}

extension WorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func getExercises() {
        var rawExercises = [Int]()
        db.collection("users").document(userDocumentId).collection("customWorkouts").whereField("nome", isEqualTo: workoutName).getDocuments { snapshot, err in
            if err != nil {
                print(err!.localizedDescription)
            } else {
                for document in snapshot!.documents {
                    let documentExercises = document.get("exercicios") as! [Int]
                    for i in 0...documentExercises.count-1 {
                        rawExercises.append(documentExercises[i])
                    }
                    rawExercises.sort()
                    self.exercisesNames = rawExercises
                    
                    self.db.collection("exercises").getDocuments { snapshot, err in
                        if err != nil {
                            print(err!.localizedDescription)
                        } else {
                            for document in snapshot!.documents {
                                let documentName = document.get("nome") as! Int
                                for i in 0...self.exercisesNames.count-1 {
                                    print("documentName:")
                                    print(documentName)
                                    print("i:")
                                    print(i)
                                    if documentName == self.exercisesNames[i] {
                                        print("If acessado!")
                                        print(i)
                                        let documentImage = URL(string: document.get("imagem") as! String)
                                        let documentDescription = document.get("obsevacoes") as! String
                                        self.exercises.append(Exercicio(nome: documentName,
                                                                           imagem: documentImage!,
                                                                           observacoes: documentDescription))
                                    }
                                }
                            }
                            self.exercisesTableView.reloadData()
                        }
                    }
                }
            }
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath) as? CustomCell else { fatalError() }
        
        cell.titleLabel.text = String(exercises[indexPath.row].nome)
        cell.descriptionLabel.text = exercises[indexPath.row].observacoes
        
        let iconView = UIImageView()
        iconView.sd_setImage(with: exercises[indexPath.row].imagem)
        cell.icon.image = iconView.image

        return cell
    }

}
